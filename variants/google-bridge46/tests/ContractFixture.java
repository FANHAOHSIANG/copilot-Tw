package com.navipilot.obf;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import org.json.JSONObject;

/** Emits actual adapter output for the downstream receiver contract replay. */
public final class ContractFixture {
    public static void main(String[] args) throws Exception {
        JSONObject nav = new JSONObject("{\"v\":1,\"sessionId\":\"contract-host-only\",\"state\":\"navigating\",\"simulated\":false,\"navAgeMs\":0,\"routeVer\":1,\"loc\":{\"lat\":25,\"lng\":121,\"acc\":5,\"ageMs\":0},\"step\":{\"maneuver\":\"turn\",\"modifier\":\"right\",\"dist\":180},\"next\":[{\"maneuver\":\"turn\",\"modifier\":\"left\",\"distFromPrev\":260}],\"remain\":{\"dist\":5000,\"time\":500}}");
        WideGoogleAdapter.Snapshot s = WideGoogleAdapter.parse(nav, null, 1000);
        JSONObject fixture = new JSONObject().put("guidance_current", s.current)
                .put("guidance_next", s.next).put("navigation_status", s.status);
        Files.write(Paths.get(args[0]), fixture.toString(2).getBytes(StandardCharsets.UTF_8));
    }
}
