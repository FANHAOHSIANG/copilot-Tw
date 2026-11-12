package com.navipilot.obf;

import android.content.Context;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.speech.tts.TextToSpeech;
import android.speech.tts.UtteranceProgressListener;
import android.speech.tts.Voice;
import java.util.Locale;
import java.util.Set;

/** Short Chinese announcements, without network TTS, replay queues or changing media volume. */
final class WideEnforcementVoice {
    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static TextToSpeech tts;
    private static AudioManager audio;
    private static AudioFocusRequest focus;
    private static boolean ready;
    private static String activeId = "", activeOwner = "", activeKey = "", activeSignature = "";
    private static long serial, startedAt;
    private static int initGeneration;
    private static volatile String state = "科技執法語音尚未初始化";
    private static final Runnable WATCH = new Runnable() { public void run() {
        if (activeId.isEmpty()) return;
        if (SystemClock.elapsedRealtime() - startedAt > 15000
                || (!"preview".equals(activeOwner) && !WideEnforcementRuntime.isSpeechCurrent(activeOwner, activeSignature))) {
            stop("提醒已過期或目標已變更，語音已撤銷");
        } else MAIN.postDelayed(this, 350);
    }};

    private static void init(Context c) {
        if (tts != null) return;
        audio = (AudioManager)c.getSystemService(Context.AUDIO_SERVICE);
        state = "正在初始化中文語音，稍後可再次試聽";
        final int generation = ++initGeneration;
        tts = new TextToSpeech(c.getApplicationContext(), new TextToSpeech.OnInitListener() {
            public void onInit(final int result) { MAIN.post(new Runnable() { public void run() {
                if (generation == initGeneration) initialized(result);
            }}); }
        });
    }
    static void warmup(Context c) { if (c != null) init(c); }
    private static void initialized(int result) {
        if (tts == null || result != TextToSpeech.SUCCESS) { state = "中文語音引擎無法啟動，請檢查系統文字轉語音設定"; return; }
        try {
            Set<Voice> voices = tts.getVoices();
            Voice chosen = null;
            if (voices != null) for (Voice v : voices) {
                if (v.isNetworkConnectionRequired() || !"zh".equals(v.getLocale().getLanguage())) continue;
                if (chosen == null || ("TW".equals(v.getLocale().getCountry())
                        && !"TW".equals(chosen.getLocale().getCountry()))) chosen = v;
            }
            if (chosen == null) {
                state = "尚無離線中文語音，請到系統安裝中文語音資料";
                return;
            }
            int language = tts.setLanguage(chosen.getLocale());
            if (language < TextToSpeech.LANG_AVAILABLE || tts.setVoice(chosen) == TextToSpeech.ERROR) {
                state = "中文語音資料不可用，請重新下載語音資料"; return;
            }
            AudioAttributes attributes = new AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ASSISTANCE_NAVIGATION_GUIDANCE)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build();
            tts.setAudioAttributes(attributes);
            tts.setSpeechRate(1.0f);
            focus = new AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
                    .setAudioAttributes(attributes).setWillPauseWhenDucked(true)
                    .setAcceptsDelayedFocusGain(false)
                    .setOnAudioFocusChangeListener(new AudioManager.OnAudioFocusChangeListener() {
                        public void onAudioFocusChange(int value) {
                            if (value < 0) stop("其他音訊取得優先權，科技執法語音已暫停");
                        }
                    }, MAIN).build();
            tts.setOnUtteranceProgressListener(new UtteranceProgressListener() {
                public void onStart(final String id) { MAIN.post(new Runnable() { public void run() {
                    if (!id.equals(activeId)) return;
                    if (!"preview".equals(activeOwner)
                            && !WideEnforcementRuntime.isSpeechCurrent(activeOwner, activeSignature)) {
                        stop("開始播放前提醒條件已改變，語音已撤銷");
                        return;
                    }
                    state = "中文語音播放中";
                }}); }
                public void onDone(final String id) { finish(id, "中文語音引擎已完成播放"); }
                public void onError(final String id) { finish(id, "中文語音播放失敗，請檢查系統語音與音量"); }
                public void onStop(final String id, boolean interrupted) { finish(id, "中文語音已停止"); }
            });
            ready = true;
            state = "離線中文語音已就緒（" + chosen.getLocale().toLanguageTag() + "）";
        } catch (RuntimeException failure) {
            ready = false; state = "中文語音設定失敗：" + failure.getClass().getSimpleName();
        }
    }
    static void speak(Context c, String text, String key, String owner, String signature, Runnable accepted) {
        if ("preview".equals(owner) && tts != null && !ready) {
            try { tts.shutdown(); } catch (RuntimeException ignored) { }
            tts = null;
        }
        init(c);
        if (!ready || text == null || text.isEmpty() || audio == null || focus == null) return;
        if (key.equals(activeKey) && signature.equals(activeSignature)) return;
        if (!"preview".equals(owner) && !WideEnforcementRuntime.isSpeechCurrent(owner, signature)) return;
        if (!activeId.isEmpty()) stop("切換提醒");
        try {
            if (audio.requestAudioFocus(focus) != AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
                state = "音訊暫不可用，本次語音不排隊"; return;
            }
            activeId = "enforcement-" + (++serial);
            activeKey = key; activeOwner = owner; activeSignature = signature; startedAt = SystemClock.elapsedRealtime();
            int result = tts.speak(text, TextToSpeech.QUEUE_FLUSH, new Bundle(), activeId);
            if (result != TextToSpeech.SUCCESS) { stop("語音引擎未接受提醒"); return; }
            state = "語音引擎已接受提醒；裝置音量仍需確認";
            MAIN.removeCallbacks(WATCH); MAIN.postDelayed(WATCH, 350);
            if (accepted != null) accepted.run();
        } catch (RuntimeException failure) { stop("語音播放失敗：" + failure.getClass().getSimpleName()); }
    }
    private static void finish(final String id, final String message) {
        MAIN.post(new Runnable() { public void run() {
            if (!id.equals(activeId)) return;
            activeId = ""; activeKey = ""; activeOwner = ""; activeSignature = "";
            MAIN.removeCallbacks(WATCH); releaseFocus(); state = message;
        }});
    }
    static void stop(String reason) {
        if (!activeId.isEmpty()) {
            activeId = ""; activeKey = ""; activeOwner = ""; activeSignature = "";
            if (tts != null) try { tts.stop(); } catch (RuntimeException ignored) { }
            releaseFocus(); state = reason;
        }
        MAIN.removeCallbacks(WATCH);
    }
    private static void releaseFocus() {
        if (audio != null && focus != null) try { audio.abandonAudioFocusRequest(focus); } catch (RuntimeException ignored) { }
    }
    static String status() { return state; }
    private WideEnforcementVoice() { }
}
