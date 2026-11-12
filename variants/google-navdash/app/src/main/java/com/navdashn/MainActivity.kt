package com.navdashn

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.view.View
import android.view.WindowManager
import android.view.inputmethod.EditorInfo
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.gms.common.api.ApiException
import com.google.android.libraries.navigation.NavigationApi
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.AutocompleteSessionToken
import com.google.android.libraries.places.api.net.FetchPlaceRequest
import com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest
import com.google.android.libraries.places.api.net.PlacesClient
import com.navdashn.databinding.ActivityMainBinding
import com.navdashn.navigation.NavController
import com.navdashn.navigation.NavHttpServer
import com.navdashn.navigation.NavService
import com.navdashn.navigation.NavState
import com.navdashn.navigation.PlaceItem
import com.navdashn.navigation.PlacesAdapter
import com.navdashn.utils.PreferenceManager
import kotlinx.coroutines.launch

/**
 * 主畫面：設定目的地（搜尋 / 常用 / 最近）＋導航狀態。
 * 開始導航後自動進入 Google 導航畫面（GuidanceActivity）。
 */
class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private lateinit var preferenceManager: PreferenceManager
    private var placesClient: PlacesClient? = null
    private var sessionToken: AutocompleteSessionToken? = null
    private var pendingSearch: Runnable? = null
    private var searchGeneration = 0
    private var desiredSearchQuery = ""
    private var lastRequestGeneration = -1
    private val destinationRequests = RequestGeneration()
    private var lastRequestedQuery = ""
    private var lastRequestElapsedMs = -1L

    // 開始導航後只自動開一次導航畫面
    private var openGuidanceWhenNavigating = false

    private val searchAdapter = PlacesAdapter(
        onPlaceClick = { place -> onPlaceSelected(place) },
        onPlaceLongClick = { place -> onAddToFavorites(place) }
    )
    private val favoritesAdapter = PlacesAdapter(
        onPlaceClick = { place -> onPlaceSelected(place) },
        onPlaceLongClick = { place -> onRemoveFromFavorites(place) }
    )
    private val recentAdapter = PlacesAdapter(
        onPlaceClick = { place -> onPlaceSelected(place) },
        onPlaceLongClick = { place -> onAddToFavorites(place) }
    )

    private val handler = Handler(Looper.getMainLooper())
    private val statusRunnable = object : Runnable {
        override fun run() {
            updateStatus()
            handler.postDelayed(this, 1000)
        }
    }

    // 語音輸入目的地（Google 語音辨識，zh-TW）：聽到的字放進搜尋框並直接搜尋
    private val voiceRequest = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        val text = result.data?.getStringArrayListExtra(android.speech.RecognizerIntent.EXTRA_RESULTS)?.firstOrNull()
        if (result.resultCode == RESULT_OK && !text.isNullOrBlank()) {
            binding.searchInput.setText(text)
            binding.searchInput.setSelection(text.length)
            scheduleAutocomplete(text, true)
        }
    }

    private val permissionRequest = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { result ->
        if (result[Manifest.permission.ACCESS_FINE_LOCATION] == true) {
            onLocationPermissionGranted()
        } else {
            Toast.makeText(this, getString(R.string.need_location), Toast.LENGTH_LONG).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (!GoogleReady.ensure(this)) return
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        preferenceManager = PreferenceManager(this)

        setupSearch()
        setupLists()
        setupButtons()
        initPlacesApi()
        loadFavorites()
        loadRecents()

        NavController.setOnNavigationStateChangedListener { state ->
            runOnUiThread {
                if (isFinishing || isDestroyed) return@runOnUiThread
                updateStatus()
                if (state == NavState.NAVIGATING && openGuidanceWhenNavigating) {
                    openGuidanceWhenNavigating = false
                    openGuidance()
                }
                if (state == NavState.ERROR) {
                    openGuidanceWhenNavigating = false
                    val err = NavController.getLastRouteError()
                    if (err.isNotBlank()) Toast.makeText(this, err, Toast.LENGTH_LONG).show()
                }
            }
        }
        NavController.setOnInitErrorListener { message, code ->
            runOnUiThread {
                if (isFinishing || isDestroyed) return@runOnUiThread
                if (code == NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED) showTerms()
                else Toast.makeText(this, message, Toast.LENGTH_LONG).show()
                updateStatus()
            }
        }

        requestPermissionsIfNeeded()
    }

    override fun onResume() {
        super.onResume()
        if (::binding.isInitialized && !isFinishing) handler.post(statusRunnable)
    }

    override fun onPause() {
        super.onPause()
        handler.removeCallbacks(statusRunnable)
        cancelPendingSearch()
    }

    override fun onDestroy() {
        destinationRequests.close()
        cancelPendingSearch()
        handler.removeCallbacks(statusRunnable)
        openGuidanceWhenNavigating = false
        super.onDestroy()
    }

    private fun cancelDestinationRequest() {
        destinationRequests.cancel()
        openGuidanceWhenNavigating = false
        cancelPendingSearch()
    }

    // ------------------------------------------------------------------ 權限 / 初始化

    private fun requestPermissionsIfNeeded() {
        val needed = mutableListOf<String>()
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED) {
            needed += Manifest.permission.ACCESS_FINE_LOCATION
            needed += Manifest.permission.ACCESS_COARSE_LOCATION
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)
            != PackageManager.PERMISSION_GRANTED) {
            needed += Manifest.permission.POST_NOTIFICATIONS
        }
        if (needed.isEmpty()) onLocationPermissionGranted()
        else permissionRequest.launch(needed.toTypedArray())
    }

    private fun onLocationPermissionGranted() {
        ContextCompat.startForegroundService(this, Intent(this, NavService::class.java))
        NavController.init(this)
    }

    private fun showTerms() {
        NavController.showTermsAndConditions(
            this,
            onAccepted = { NavController.init(this) },
            onRejected = {
                Toast.makeText(this, getString(R.string.terms_rejected), Toast.LENGTH_LONG).show()
            }
        )
    }

    // ------------------------------------------------------------------ 按鈕 / 狀態

    private fun setupButtons() {
        binding.openGuidanceButton.setOnClickListener { openGuidance() }
        binding.stopNavButton.setOnClickListener {
            cancelDestinationRequest()
            NavController.stopNavigation()
            Toast.makeText(this, getString(R.string.nav_stopped), Toast.LENGTH_SHORT).show()
            updateStatus()
        }
        binding.simulateButton.setOnClickListener {
            if (NavController.isSimulating) {
                cancelDestinationRequest()
                NavController.stopSimulation()
                Toast.makeText(this, "已停止模擬並撤銷導航；請重新選擇目的地開始真實導航。", Toast.LENGTH_LONG).show()
            } else NavController.startSimulation()
            updateStatus()
        }
        binding.acceptTermsButton.setOnClickListener { showTerms() }
        binding.initSdkButton.setOnClickListener { requestPermissionsIfNeeded() }
        binding.helpButton.setOnClickListener { startActivity(Intent(this, HelpActivity::class.java)) }
        binding.exitButton.setOnClickListener {
            if (NavController.isNavigating()) {
                com.google.android.material.dialog.MaterialAlertDialogBuilder(this)
                    .setMessage(R.string.exit_confirm)
                    .setPositiveButton(R.string.exit_ok) { _, _ -> exitApp() }
                    .setNegativeButton(R.string.cancel, null)
                    .show()
            } else exitApp()
        }
    }

    /** 真正結束：停導航、放掉 Navigation SDK、停前景服務（連 :5002 一起），關掉所有畫面後結束行程。 */
    private fun exitApp() {
        cancelDestinationRequest()
        try { NavController.stopNavigation() } catch (_: Exception) {}
        try { NavController.release() } catch (_: Exception) {}
        stopService(Intent(this, NavService::class.java))
        finishAndRemoveTask()
        handler.postDelayed({ android.os.Process.killProcess(android.os.Process.myPid()) }, 400)
    }

    private fun startVoiceSearch() {
        val intent = Intent(android.speech.RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(android.speech.RecognizerIntent.EXTRA_LANGUAGE_MODEL, android.speech.RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(android.speech.RecognizerIntent.EXTRA_LANGUAGE, "zh-TW")
            putExtra(android.speech.RecognizerIntent.EXTRA_PROMPT, getString(R.string.voice_prompt))
            putExtra(android.speech.RecognizerIntent.EXTRA_MAX_RESULTS, 1)
        }
        try {
            voiceRequest.launch(intent)
        } catch (e: android.content.ActivityNotFoundException) {
            Toast.makeText(this, getString(R.string.voice_unavailable), Toast.LENGTH_LONG).show()
        }
    }

    private fun openGuidance() {
        startActivity(Intent(this, GuidanceActivity::class.java))
    }

    private fun updateStatus() {
        val ready = NavController.isReady()
        val state = NavController.getState()
        val (lastError, lastErrorCode) = NavController.getLastError()

        binding.piStatusText.text = piStatusText()

        if (!ready) {
            binding.navStatusText.text = when {
                lastErrorCode == NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED -> getString(R.string.terms_required)
                lastError.isNotBlank() -> getString(R.string.sdk_init_error, lastError)
                else -> getString(R.string.sdk_not_ready)
            }
            binding.acceptTermsButton.visibility =
                if (lastErrorCode == NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED) View.VISIBLE else View.GONE
            binding.initSdkButton.visibility =
                if (lastErrorCode != NavigationApi.ErrorCode.TERMS_NOT_ACCEPTED) View.VISIBLE else View.GONE
            binding.openGuidanceButton.visibility = View.GONE
            binding.stopNavButton.visibility = View.GONE
            binding.simulateButton.visibility = View.GONE
            return
        }
        binding.acceptTermsButton.visibility = View.GONE
        binding.initSdkButton.visibility = View.GONE

        val navigating = NavController.isNavigating()
        binding.navStatusText.text = when (state) {
            NavState.IDLE -> getString(R.string.not_navigating)
            NavState.ROUTING -> getString(R.string.routing)
            NavState.REROUTING -> getString(R.string.rerouting)
            NavState.ARRIVED -> getString(R.string.arrived)
            NavState.ERROR -> NavController.getLastRouteError().ifBlank { getString(R.string.nav_error) }
            NavState.NAVIGATING -> {
                val (dist, sec, eta) = NavController.getRemaining()
                buildString {
                    append(getString(R.string.navigating_to, NavController.getCurrentDestination() ?: ""))
                    if (dist > 0) {
                        append("\n")
                        append(getString(R.string.remaining_distance_time, dist / 1000.0, sec / 60))
                    }
                    if (eta.isNotBlank()) append("  ").append(getString(R.string.eta, eta))
                }
            }
        }
        binding.openGuidanceButton.visibility = if (navigating) View.VISIBLE else View.GONE
        binding.stopNavButton.visibility = if (navigating) View.VISIBLE else View.GONE
        binding.simulateButton.visibility = if (navigating) View.VISIBLE else View.GONE
        binding.simulateButton.text = getString(
            if (NavController.isSimulating) R.string.simulate_stop else R.string.simulate_start
        )
    }

    private fun piStatusText(): String {
        val last = NavHttpServer.lastNavReadElapsedMs
        if (last == 0L) return getString(R.string.pi_never)
        val ago = (SystemClock.elapsedRealtime() - last) / 1000
        return if (ago <= 5) getString(R.string.pi_connected, NavHttpServer.lastNavReader)
        else getString(R.string.pi_stale, ago)
    }

    // ------------------------------------------------------------------ 搜尋（沿用原 NavActivity）

    private fun setupSearch() {
        binding.searchInput.setOnEditorActionListener { _, actionId, _ ->
            if (actionId == EditorInfo.IME_ACTION_SEARCH || actionId == EditorInfo.IME_ACTION_DONE) {
                val query = binding.searchInput.text.toString()
                if (query.length >= 2) scheduleAutocomplete(query, true)
                hideKeyboard()
                true
            } else false
        }
        binding.searchInput.addTextChangedListener(object : android.text.TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: android.text.Editable?) {
                val query = s?.toString() ?: ""
                binding.clearSearchButton.visibility = if (query.isNotEmpty()) View.VISIBLE else View.GONE
                if (binding.searchInput.hasFocus() && query.length >= 2) scheduleAutocomplete(query)
                else if (query.length < 2) { cancelPendingSearch(); hideSearchResults() }
            }
        })
        binding.voiceSearchButton.setOnClickListener { startVoiceSearch() }
        binding.clearSearchButton.setOnClickListener {
            binding.searchInput.text?.clear()
            hideSearchResults()
        }
        binding.searchButton.setOnClickListener {
            val query = binding.searchInput.text.toString()
            if (query.length >= 2) {
                scheduleAutocomplete(query, true)
                hideKeyboard()
            } else {
                Toast.makeText(this, "請輸入至少 2 個字", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun hideKeyboard() {
        val imm = getSystemService(INPUT_METHOD_SERVICE) as android.view.inputmethod.InputMethodManager
        imm.hideSoftInputFromWindow(binding.searchInput.windowToken, 0)
    }

    private fun setupLists() {
        binding.searchResults.layoutManager = LinearLayoutManager(this)
        binding.searchResults.adapter = searchAdapter
        binding.favoritesList.layoutManager = LinearLayoutManager(this)
        binding.favoritesList.adapter = favoritesAdapter
        binding.recentList.layoutManager = LinearLayoutManager(this)
        binding.recentList.adapter = recentAdapter
    }

    private fun initPlacesApi() {
        try {
            val apiKey = com.navipilot.google.GoogleKeySettings.read(this)
            if (apiKey.isBlank()) {
                Toast.makeText(this, "API Key 未設定", Toast.LENGTH_LONG).show()
                return
            }
            if (!Places.isInitialized()) Places.initializeWithNewPlacesApiEnabled(applicationContext, apiKey)
            placesClient = Places.createClient(this)
            sessionToken = AutocompleteSessionToken.newInstance()
        } catch (e: Exception) {
            Toast.makeText(this, "Places API 初始化失敗，請檢查金鑰與 Google Cloud 設定。", Toast.LENGTH_LONG).show()
        }
    }

    private fun cancelPendingSearch() {
        pendingSearch?.let { handler.removeCallbacks(it) }
        pendingSearch = null
        searchGeneration++
        desiredSearchQuery = ""
    }

    private fun scheduleAutocomplete(input: String, immediate: Boolean = false) {
        val query = input.trim()
        if (query != desiredSearchQuery) {
            cancelPendingSearch()
            desiredSearchQuery = query
        } else {
            pendingSearch?.let { handler.removeCallbacks(it) }
            pendingSearch = null
        }
        if (query.length < 2) { hideSearchResults(); return }
        val generation = searchGeneration
        val work = Runnable { performAutocomplete(query, generation) }
        pendingSearch = work
        if (immediate) work.run() else handler.postDelayed(work, GoogleSearchPolicy.DEBOUNCE_MS)
    }

    private fun performAutocomplete(query: String, generation: Int) {
        val client = placesClient ?: return
        if (generation != searchGeneration) return
        val now = SystemClock.elapsedRealtime()
        if (lastRequestGeneration == generation
            && !GoogleSearchPolicy.shouldRequest(query, lastRequestedQuery, now, lastRequestElapsedMs)) return
        lastRequestGeneration = generation
        lastRequestedQuery = query
        lastRequestElapsedMs = now
        val token = sessionToken ?: AutocompleteSessionToken.newInstance().also { sessionToken = it }
        val request = FindAutocompletePredictionsRequest.builder()
            .setSessionToken(token)
            .setQuery(query)
            .setCountries("TW")
            .build()
        client.findAutocompletePredictions(request)
            .addOnSuccessListener { response ->
                if (generation != searchGeneration || isFinishing || isDestroyed) return@addOnSuccessListener
                showSearchResults(response.autocompletePredictions.map { p ->
                    PlaceItem(
                        id = p.placeId,
                        name = p.getPrimaryText(null).toString(),
                        address = p.getSecondaryText(null).toString(),
                        icon = "📍"
                    )
                })
            }
            .addOnFailureListener { e ->
                if (generation != searchGeneration || isFinishing || isDestroyed) return@addOnFailureListener
                val code = (e as? ApiException)?.statusCode ?: -1
                android.util.Log.w("MainActivity", "Places autocomplete rejected: status=$code")
                Toast.makeText(this, GoogleSearchPolicy.errorMessage(code), Toast.LENGTH_LONG).show()
            }
    }

    private fun showSearchResults(places: List<PlaceItem>) {
        searchAdapter.submitList(places)
        binding.searchResults.visibility = if (places.isNotEmpty()) View.VISIBLE else View.GONE
    }

    private fun hideSearchResults() {
        binding.searchResults.visibility = View.GONE
        searchAdapter.submitList(emptyList())
    }

    private fun onPlaceSelected(place: PlaceItem) {
        val destinationGeneration = destinationRequests.begin()
        cancelPendingSearch()
        val chosenSession = sessionToken
        sessionToken = AutocompleteSessionToken.newInstance()
        lastRequestedQuery = ""
        hideKeyboard()
        hideSearchResults()
        binding.searchInput.text?.clear()

        if (!NavController.isReady()) {
            Toast.makeText(this, getString(R.string.sdk_not_ready), Toast.LENGTH_LONG).show()
            return
        }

        // 常用/最近已存座標就直接用，不用再查一次
        if (place.lat != null && place.lng != null) {
            startNavigation(place, place.lat, place.lng, place.address)
            return
        }

        val client = placesClient ?: return
        val request = FetchPlaceRequest.builder(
            place.id, GoogleSearchPolicy.detailsFields()
        ).setSessionToken(chosenSession).build()
        client.fetchPlace(request)
            .addOnSuccessListener { response ->
                if (!destinationRequests.accepts(destinationGeneration) || isFinishing || isDestroyed) return@addOnSuccessListener
                val latLng = response.place.latLng
                if (latLng == null) {
                    Toast.makeText(this, "無法取得地點座標", Toast.LENGTH_LONG).show()
                    return@addOnSuccessListener
                }
                val address = GoogleSearchPolicy.address(place.address)
                startNavigation(place.copy(lat = latLng.latitude, lng = latLng.longitude, address = address),
                    latLng.latitude, latLng.longitude, address)
            }
            .addOnFailureListener { e ->
                if (!destinationRequests.accepts(destinationGeneration) || isFinishing || isDestroyed) return@addOnFailureListener
                val code = (e as? ApiException)?.statusCode ?: -1
                Toast.makeText(this, "取得地點資訊失敗：" + GoogleSearchPolicy.errorMessage(code), Toast.LENGTH_LONG).show()
            }
    }

    private fun startNavigation(place: PlaceItem, lat: Double, lng: Double, address: String) {
        lifecycleScope.launch { preferenceManager.addRecent(place) }
        openGuidanceWhenNavigating = true
        NavController.startNavigation(lat, lng, GoogleSearchPolicy.title(place.name, address), address)
        Toast.makeText(this, getString(R.string.routing), Toast.LENGTH_SHORT).show()
    }

    private fun onAddToFavorites(place: PlaceItem): Boolean {
        lifecycleScope.launch {
            preferenceManager.addFavorite(place.copy(icon = "⭐"))
            Toast.makeText(this@MainActivity, getString(R.string.added_to_favorites, place.name), Toast.LENGTH_SHORT).show()
        }
        return true
    }

    private fun onRemoveFromFavorites(place: PlaceItem): Boolean {
        com.google.android.material.dialog.MaterialAlertDialogBuilder(this)
            .setTitle(R.string.remove_favorite_title)
            .setMessage(getString(R.string.remove_favorite_message, place.name))
            .setPositiveButton(R.string.remove) { _, _ ->
                lifecycleScope.launch { preferenceManager.removeFavorite(place.id) }
            }
            .setNegativeButton(R.string.cancel, null)
            .show()
        return true
    }

    private fun loadFavorites() {
        lifecycleScope.launch {
            preferenceManager.favorites.collect { list ->
                favoritesAdapter.submitList(list)
                binding.favoritesCard.visibility = if (list.isEmpty()) View.GONE else View.VISIBLE
            }
        }
    }

    private fun loadRecents() {
        lifecycleScope.launch {
            preferenceManager.recents.collect { list ->
                recentAdapter.submitList(list)
                binding.recentCard.visibility = if (list.isEmpty()) View.GONE else View.VISIBLE
            }
        }
    }
}
