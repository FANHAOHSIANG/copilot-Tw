package com.navipilot.obf;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;
import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import org.json.JSONArray;
import org.json.JSONObject;

/** Exercises data integrity and resource boundaries, using independently generated fixtures. */
public final class CodecChecks {
    private static int checks;
    private interface Operation { void run() throws Exception; }

    private static void check(boolean condition, String message) {
        checks++;
        if (!condition) throw new AssertionError(message);
    }

    private static void rejects(Operation operation, String message) throws Exception {
        checks++;
        try {
            operation.run();
        } catch (Exception expected) {
            return;
        }
        throw new AssertionError(message);
    }

    private static String instruction() throws Exception {
        return new JSONObject().put("curManeuverID", 2).put("segmentRemainDist", 38)
                .put("nextRouteName", "測試道路甲").put("routeRemainDist", 28_000).toString();
    }

    private static String business() throws Exception {
        JSONArray items = new JSONArray()
                .put(new JSONObject().put("type", 4).put("data", instruction()))
                .put(new JSONObject().put("type", 7).put("data", new JSONObject()))
                .put(new JSONObject().put("type", 100).put("data", JSONObject.NULL));
        return new JSONObject().put("bizType", 113).put("datas", items.toString()).toString();
    }

    private static byte[] bytes(String text) { return text.getBytes(StandardCharsets.UTF_8); }

    private static String encoded(byte[] raw) { return Base64.getEncoder().encodeToString(raw); }

    private static String begin(String id, int size, int chunks) throws Exception {
        return new JSONObject().put("type", "begin_transfer").put("transferId", id)
                .put("totalSize", size).put("totalChunks", chunks).toString();
    }

    private static String chunk(String id, int index, byte[] data) throws Exception {
        return new JSONObject().put("type", "chunk_data").put("transferId", id)
                .put("chunkIndex", index).put("data", encoded(data)).toString();
    }

    private static String end(String id) throws Exception {
        return new JSONObject().put("type", "end_transfer").put("transferId", id)
                .put("status", "success").toString();
    }

    private static void plaintextAndBusinessShapes() throws Exception {
        String raw = business();
        check(raw.equals(WideAmapLinkCodec.decodeEnvelope(raw)), "plaintext business survives unchanged");
        List<WideAmapLinkCodec.Item> items = WideAmapLinkCodec.items(raw);
        check(items.size() == 3, "string-valued datas contains all three business items");
        check(items.get(0).type == 4, "type 4 preserved");
        check(items.get(0).data.getInt("segmentRemainDist") == 38, "nested data JSON decoded");
        check("測試道路甲".equals(items.get(0).data.getString("nextRouteName")), "UTF-8 road preserved");
        check(items.get(2).type == 100 && items.get(2).data.length() == 0,
                "null lifecycle data is an empty object, not a dropped stop");
        JSONArray array = new JSONArray().put(new JSONObject().put("type", 4)
                .put("data", new JSONObject(instruction())));
        check(WideAmapLinkCodec.items(new JSONObject().put("bizType", 113).put("datas", array).toString())
                .get(0).data.getInt("curManeuverID") == 2, "object data and array datas supported");
        check(WideAmapLinkCodec.objectValue(instruction()).getInt("segmentRemainDist") == 38,
                "single string object supported");
        String escaped = URLEncoder.encode(instruction(), "UTF-8");
        check(WideAmapLinkCodec.objectValue(escaped).getInt("segmentRemainDist") == 38,
                "URI-escaped object supported");
        rejects(() -> WideAmapLinkCodec.objectValue("not JSON"), "malformed data cannot become a valid object");
    }

    private static byte[] encryptedPacket(String plain, int keySize) throws Exception {
        // These deterministic test bytes are synthetic transport fixture material, not credentials.
        byte[] id = bytes("copilot-test-fixture");
        byte[] key = new byte[keySize];
        byte[] nonce = new byte[12];
        for (int i = 0; i < key.length; i++) key[i] = (byte) (31 + i);
        for (int i = 0; i < nonce.length; i++) nonce[i] = (byte) (81 + i);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(key, "AES"), new GCMParameterSpec(128, nonce));
        cipher.updateAAD(id);
        byte[] body = cipher.doFinal(bytes(plain));
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        DataOutputStream data = new DataOutputStream(output);
        data.writeInt(id.length);
        data.write(id);
        data.writeInt(key.length);
        data.write(key);
        data.write(nonce);
        data.write(body);
        data.close();
        return output.toByteArray();
    }

    private static void authenticatedEnvelopeIntegrity() throws Exception {
        String plain = business();
        for (int keySize : new int[] {16, 24, 32}) {
            byte[] packet = encryptedPacket(plain, keySize);
            String bare = encoded(packet);
            check(plain.equals(WideAmapLinkCodec.decodeEnvelope(bare)), "valid GCM packet key size " + keySize);
            String wrapped = new JSONObject().put("encrypted", true).put("content", bare).toString();
            check(plain.equals(WideAmapLinkCodec.decodeEnvelope(wrapped)), "explicit encrypted wrapper");
            packet[packet.length - 1] ^= 1;
            rejects(() -> WideAmapLinkCodec.decodeEnvelope(encoded(packet)), "tampered GCM tag rejected");
        }
        byte[] valid = encryptedPacket(plain, 16);
        byte[] modifiedAad = valid.clone();
        modifiedAad[4] ^= 1;
        rejects(() -> WideAmapLinkCodec.decodeEnvelope(encoded(modifiedAad)), "AAD tampering rejected");
        rejects(() -> WideAmapLinkCodec.decodeEnvelope(encoded(Arrays.copyOf(valid, 12))),
                "truncated encryption header rejected");
        byte[] invalidLength = valid.clone();
        Arrays.fill(invalidLength, 0, 4, (byte) 0x7f);
        rejects(() -> WideAmapLinkCodec.decodeEnvelope(encoded(invalidLength)), "unbounded id length rejected");
        rejects(() -> WideAmapLinkCodec.decodeEnvelope(new JSONObject().put("encrypted", true)
                .put("content", "not base64!").toString()), "bad encrypted wrapper rejected");
    }

    private static void outOfOrderAndDuplicateChunks() throws Exception {
        WideAmapLinkCodec.Payload payload = new WideAmapLinkCodec.Payload();
        byte[] raw = bytes(business());
        int split = raw.length / 2;
        byte[] first = Arrays.copyOfRange(raw, 0, split);
        byte[] last = Arrays.copyOfRange(raw, split, raw.length);
        check(payload.accept(begin("a", raw.length, 2), 1_000) == null, "begin is not business data");
        check(payload.outputReceivedElapsedMs() == -1, "incomplete transfer has no completed receipt");
        check(payload.activeTransfers() == 1, "begin allocates one bounded transfer");
        check(payload.accept(chunk("a", 1, last), 1_001) == null, "last chunk first remains incomplete");
        check(payload.accept(chunk("a", 1, last), 1_002) == null, "identical duplicate is harmless");
        check(payload.accept(chunk("a", 0, first), 1_003) == null, "all chunks still await success marker");
        check(business().equals(payload.accept(end("a"), 1_004)), "chunks assemble by index, not arrival order");
        check(payload.outputReceivedElapsedMs() == 1_000, "completion retains begin receipt, not end receipt");
        check(payload.activeTransfers() == 0, "finished transfer releases storage");
    }

    private static void mismatchedAndConflictingChunks() throws Exception {
        WideAmapLinkCodec.Payload payload = new WideAmapLinkCodec.Payload();
        payload.accept(begin("a", 4, 2), 1_000);
        payload.accept(chunk("a", 0, bytes("ab")), 1_001);
        rejects(() -> payload.accept(chunk("a", 0, bytes("ac")), 1_002), "conflicting duplicate rejected");
        check(payload.activeTransfers() == 0, "conflicting duplicate discards affected transfer");
        payload.accept(begin("b", 5, 2), 2_000);
        payload.accept(chunk("b", 0, bytes("ab")), 2_001);
        payload.accept(chunk("b", 1, bytes("cd")), 2_002);
        rejects(() -> payload.accept(end("b"), 2_003), "declared length mismatch rejected");
        check(payload.activeTransfers() == 0, "length mismatch releases storage");
        payload.accept(begin("c", 4, 2), 3_000);
        rejects(() -> payload.accept(chunk("c", 2, bytes("ab")), 3_001), "out-of-range chunk index rejected");
        check(payload.activeTransfers() == 0, "bad index discards affected transfer");
    }

    private static void expiryAndGenerationReset() throws Exception {
        WideAmapLinkCodec.Payload payload = new WideAmapLinkCodec.Payload();
        payload.accept(begin("old", 4, 2), 1_000);
        payload.accept(chunk("old", 0, bytes("ab")), 1_001);
        check("{}".equals(payload.accept("{}", 11_002)), "ordinary payload also runs transfer expiry");
        check(payload.activeTransfers() == 0, "incomplete transfer expires without sleeping");
        payload.accept(begin("new", 4, 2), 12_000);
        payload.accept(chunk("new", 0, bytes("ab")), 12_001);
        payload.clear();
        check(payload.activeTransfers() == 0, "generation clear discards partial transfer");
        check(payload.outputReceivedElapsedMs() == -1, "generation clear also clears output provenance");
        // A callback from an abandoned session cannot complete a fresh transfer in this assembler.
        try {
            check(payload.accept(end("new"), 12_002) == null, "old end marker yields no business data");
        } catch (IllegalArgumentException expected) {
            check(true, "old end marker rejected");
        }
    }

    private static void decodeDelayCannotRenewChunkFreshness() throws Exception {
        WideAmapLinkCodec.Payload payload = new WideAmapLinkCodec.Payload();
        byte[] raw = bytes(business());
        payload.accept(begin("delayed", raw.length, 1), 2_000, 1_000);
        payload.accept(chunk("delayed", 0, raw), 3_000, 2_000);
        check(business().equals(payload.accept(end("delayed"), 5_000, 4_900)), "delayed valid frame assembles");
        check(payload.outputReceivedElapsedMs() == 1_000,
                "queue delay and late end marker cannot manufacture fresh navigation receipt");
        check("{}".equals(payload.accept("{}", 6_000, 5_000)), "direct frame accepted");
        check(payload.outputReceivedElapsedMs() == 5_000, "direct frame retains Binder receipt, not parse time");
    }

    private static void boundsAndLargePayload() throws Exception {
        WideAmapLinkCodec.Payload payload = new WideAmapLinkCodec.Payload();
        rejects(() -> payload.accept(begin("too-large", 4 * 1024 * 1024 + 1, 128), 1_000),
                "declared transfer over 4 MiB rejected before allocation");
        rejects(() -> payload.accept(begin("too-many", 4, 129), 1_000), "chunk count capped");
        payload.accept(begin("chunk-too-large", 32769, 2), 1_000);
        rejects(() -> payload.accept(chunk("chunk-too-large", 0, new byte[32769]), 1_001),
                "individual decoded chunk cap enforced");
        payload.clear();
        payload.accept(begin("one", 4, 2), 2_000);
        payload.accept(begin("two", 4, 2), 2_000);
        try { payload.accept(begin("three", 4, 2), 2_000); } catch (IllegalArgumentException expected) { }
        check(payload.activeTransfers() <= 2, "concurrent transfer memory is bounded");
        payload.clear();

        // Matches the observed need for >64 KiB callback support, using unrelated synthetic text.
        String large = new JSONObject().put("synthetic", "測".repeat(60_000)).toString();
        byte[] raw = bytes(large);
        check(raw.length > 65_536, "large test exceeds old 64 KiB truncation boundary");
        int count = (raw.length + 32767) / 32768;
        payload.accept(begin("large", raw.length, count), 3_000);
        for (int index = count - 1; index >= 0; index--) {
            int start = index * 32768;
            payload.accept(chunk("large", index, Arrays.copyOfRange(raw, start,
                    Math.min(raw.length, start + 32768))), 3_001 + index);
        }
        check(large.equals(payload.accept(end("large"), 3_100)),
                "large UTF-8 payload survives chunk boundaries within multibyte characters");
        check(payload.activeTransfers() == 0, "large completion releases memory");
        rejects(() -> WideAmapLinkCodec.decodeEnvelope(new JSONObject()
                .put("synthetic", "x".repeat(4 * 1024 * 1024 + 1)).toString()),
                "plaintext size cap enforced");
        rejects(() -> WideAmapLinkCodec.decodeEnvelope(new JSONObject()
                .put("synthetic", "測".repeat(1_500_000)).toString()),
                "byte cap cannot be bypassed by multibyte characters");
    }

    public static void main(String[] args) throws Exception {
        plaintextAndBusinessShapes();
        authenticatedEnvelopeIntegrity();
        outOfOrderAndDuplicateChunks();
        mismatchedAndConflictingChunks();
        expiryAndGenerationReset();
        decodeDelayCannotRenewChunkFreshness();
        boundsAndLargePayload();
        System.out.println("CodecChecks: " + checks + " assertions passed");
    }
}
