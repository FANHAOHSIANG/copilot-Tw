package com.navdashn;

import com.google.android.libraries.places.api.model.Place;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/** Small, testable decisions shared by the destination-search UI. No credentials or network I/O. */
public final class GoogleSearchPolicy {
    public static final long DEBOUNCE_MS = 350;
    public static final long DUPLICATE_WINDOW_MS = 1000;

    /** Labels already came from the selected prediction; only coordinates are still needed. */
    public static List<Place.Field> detailsFields() {
        return Collections.unmodifiableList(Arrays.asList(Place.Field.ID, Place.Field.LAT_LNG));
    }

    public static String title(String predictionName, String predictionAddress) {
        if (predictionName != null && !predictionName.trim().isEmpty()) return predictionName.trim();
        if (predictionAddress != null && !predictionAddress.trim().isEmpty()) return predictionAddress.trim();
        return "已選目的地"; // Display fallback only; no invented address or coordinates.
    }

    public static String address(String predictionAddress) {
        return predictionAddress == null ? "" : predictionAddress.trim();
    }

    public static boolean shouldRequest(String query, String previous, long now, long lastRequest) {
        if (query == null || query.trim().length() < 2) return false;
        return !query.equals(previous) || lastRequest < 0 || now < lastRequest
                || now - lastRequest >= DUPLICATE_WINDOW_MS;
    }

    public static String errorMessage(int statusCode) {
        switch (statusCode) {
            case 9010:
                return "Places 搜尋配額或請求頻率已達上限（9010）。請檢查 Google Cloud 配額、使用量與計費狀態。";
            case 9011:
                return "Places 請求遭拒（9011）。請檢查 Places API (New)、API 限制，以及套件名稱與 SHA-1。";
            case 9012:
                return "地點搜尋請求無效（9012），請重新輸入目的地。";
            case 9013:
                return "找不到這個地點（9013），請重新搜尋。";
            case 7:
                return "無法連上地點搜尋服務（7），請檢查網路。";
            default:
                return statusCode >= 0 ? "地點服務請求失敗（代碼 " + statusCode + "），請稍後重試並檢查 Google Cloud 設定。"
                        : "地點服務請求失敗，請檢查網路與 Google Cloud 設定。";
        }
    }

    private GoogleSearchPolicy() { }
}
