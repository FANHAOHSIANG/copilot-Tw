package com.navipilot.obf;

import java.io.ByteArrayOutputStream;
import java.net.URLDecoder;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.CodingErrorAction;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

/** Independent implementation of the observed AMap Link wire format.
 * No stored key, app impersonation, diagnostic capture, or navigation schema inference. */
public final class WideAmapLinkCodec {
    public static final int MAX_FRAME_BYTES = 4 * 1024 * 1024;
    public static final int MAX_WIRE_CHARS = ((MAX_FRAME_BYTES + 2) / 3) * 4 + 4096;
    public static final int MAX_OBJECT_CHARS = 131072;
    public static final int MAX_ITEMS = 512;
    private static final int MAX_NESTING = 4;

    private WideAmapLinkCodec() { }

    public static final class Item {
        public final int type;
        public final JSONObject data;
        Item(int type, JSONObject data) { this.type = type; this.data = data; }
    }

    /** Decodes only a delivered frame. The per-frame AES key is part of that frame. */
    public static String decodeEnvelope(String input) throws Exception {
        require(input != null && input.length() <= MAX_WIRE_CHARS, "envelope_size");
        String text = input.trim();
        require(!text.isEmpty(), "empty_envelope");
        String encoded;
        if (text.charAt(0) == '{') {
            JSONObject wrapper = jsonObject(text);
            Object flag = wrapper.opt("encrypted");
            if (flag == null || Boolean.FALSE.equals(flag)) {
                require(text.getBytes(StandardCharsets.UTF_8).length <= MAX_FRAME_BYTES,
                        "plaintext_size");
                return unwrapData(text);
            }
            require(Boolean.TRUE.equals(flag), "encryption_flag");
            Object content = wrapper.opt("content");
            require(content instanceof String, "encryption_content");
            encoded = (String) content;
        } else {
            encoded = text;
        }
        byte[] frame = base64(encoded, MAX_FRAME_BYTES);
        ByteBuffer bytes = ByteBuffer.wrap(frame).order(ByteOrder.BIG_ENDIAN);
        require(bytes.remaining() >= 4, "envelope_header");
        int idLength = bytes.getInt();
        require(idLength > 0 && idLength < 100 && bytes.remaining() >= idLength + 4,
                "envelope_id");
        byte[] id = new byte[idLength];
        bytes.get(id);
        int keyLength = bytes.getInt();
        require((keyLength == 16 || keyLength == 24 || keyLength == 32)
                && bytes.remaining() >= keyLength + 12 + 16, "envelope_key");
        byte[] key = new byte[keyLength];
        bytes.get(key);
        byte[] nonce = new byte[12];
        bytes.get(nonce);
        byte[] ciphertext = new byte[bytes.remaining()];
        bytes.get(ciphertext);
        try {
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(key, "AES"),
                    new GCMParameterSpec(128, nonce));
            cipher.updateAAD(id);
            byte[] plaintext = cipher.doFinal(ciphertext);
            try {
                return unwrapData(utf8(plaintext));
            } finally {
                Arrays.fill(plaintext, (byte) 0);
            }
        } finally {
            Arrays.fill(key, (byte) 0);
            Arrays.fill(frame, (byte) 0);
        }
    }

    /** Accepts object values, nested JSON strings and percent-encoded JSON objects. */
    public static JSONObject objectValue(Object value) throws Exception {
        Object decoded = structuredValue(value, MAX_OBJECT_CHARS);
        require(decoded instanceof JSONObject, "object_required");
        return (JSONObject) decoded;
    }

    /** Only the observed navigation business channel is emitted. No field meaning is inferred. */
    public static List<Item> items(String decodedEnvelope) throws Exception {
        require(decodedEnvelope != null && decodedEnvelope.length() <= MAX_WIRE_CHARS,
                "business_size");
        require(decodedEnvelope.getBytes(StandardCharsets.UTF_8).length <= MAX_FRAME_BYTES,
                "business_size");
        JSONObject root = jsonObject(decodedEnvelope);
        if (!isInteger(root.opt("bizType"), 113, 113)) return Collections.emptyList();
        Object datas = structuredValue(root.opt("datas"), MAX_WIRE_CHARS);
        require(datas instanceof JSONArray, "datas_array");
        JSONArray array = (JSONArray) datas;
        require(array.length() <= MAX_ITEMS, "item_count");
        List<Item> result = new ArrayList<Item>(array.length());
        for (int i = 0; i < array.length(); i++) {
            Object candidate = array.opt(i);
            if (!(candidate instanceof JSONObject)) continue;
            JSONObject item = (JSONObject) candidate;
            Object type = item.opt("type");
            if (!isInteger(type, 0, Integer.MAX_VALUE)) continue;
            Object value = item.opt("data");
            JSONObject object;
            if (value == null || value == JSONObject.NULL) object = new JSONObject();
            else {
                try { object = objectValue(value); }
                // Preserve the event identity so a consumer can clear an unusable current cue.
                catch (Exception malformedItem) { object = new JSONObject(); }
            }
            result.add(new Item(((Number) type).intValue(), object));
        }
        return result;
    }

    private static String unwrapData(String text) throws Exception {
        require(text.length() <= MAX_WIRE_CHARS, "plaintext_size");
        JSONObject object = jsonObject(text);
        if (object.length() == 1 && object.opt("data") instanceof String) {
            String inner = (String) object.opt("data");
            require(inner.length() <= MAX_WIRE_CHARS, "plaintext_size");
            jsonObject(inner);
            return inner;
        }
        return text;
    }

    private static Object structuredValue(Object initial, int maxChars) throws Exception {
        Object value = initial;
        for (int layer = 0; layer <= MAX_NESTING; layer++) {
            if (value instanceof JSONObject || value instanceof JSONArray) {
                require(value.toString().length() <= maxChars, "json_size");
                return value;
            }
            require(value instanceof String && layer < MAX_NESTING, "json_layers");
            String text = ((String) value).trim();
            require(!text.isEmpty() && text.length() <= maxChars, "json_size");
            if (text.startsWith("%7B") || text.startsWith("%7b")
                    || text.startsWith("%5B") || text.startsWith("%5b")
                    || text.startsWith("%22")) {
                // This is URI encoding, not application/x-www-form-urlencoded.
                value = URLDecoder.decode(text.replace("+", "%2B"), "UTF-8");
            } else value = jsonValue(text);
        }
        throw new IllegalArgumentException("json_layers");
    }

    private static JSONObject jsonObject(String text) throws Exception {
        Object object = jsonValue(text);
        require(object instanceof JSONObject, "object_required");
        return (JSONObject) object;
    }

    private static Object jsonValue(String text) throws Exception {
        // org.json uses recursive descent. Bound nesting before it reaches the parser stack.
        int depth = 0;
        char quote = 0;
        boolean escaped = false;
        for (int i = 0; i < text.length(); i++) {
            char ch = text.charAt(i);
            if (quote != 0) {
                if (escaped) escaped = false;
                else if (ch == '\\') escaped = true;
                else if (ch == quote) quote = 0;
            } else if (ch == '"' || ch == '\'') quote = ch;
            else if (ch == '/' && i + 1 < text.length()
                    && (text.charAt(i + 1) == '/' || text.charAt(i + 1) == '*'))
                throw new IllegalArgumentException("json_comment");
            else if (ch == '{' || ch == '[') require(++depth <= 64, "json_depth");
            else if (ch == '}' || ch == ']') depth--;
        }
        JSONTokener parser = new JSONTokener(text);
        Object object = parser.nextValue();
        require(parser.nextClean() == 0, "json_trailing_data");
        return object;
    }

    static boolean isInteger(Object value, long min, long max) {
        if (!(value instanceof Number)) return false;
        double number = ((Number) value).doubleValue();
        return !Double.isNaN(number) && !Double.isInfinite(number)
                && number >= min && number <= max && number == Math.rint(number);
    }

    static String utf8(byte[] data) throws CharacterCodingException {
        return StandardCharsets.UTF_8.newDecoder()
                .onMalformedInput(CodingErrorAction.REPORT)
                .onUnmappableCharacter(CodingErrorAction.REPORT)
                .decode(ByteBuffer.wrap(data)).toString();
    }

    private static byte[] base64(String text, int maxBytes) {
        require(text.length() <= MAX_WIRE_CHARS, "base64_size");
        StringBuilder compact = new StringBuilder(text.length());
        for (int i = 0; i < text.length(); i++) {
            char ch = text.charAt(i);
            if (ch != ' ' && ch != '\n' && ch != '\r' && ch != '\t') compact.append(ch);
        }
        require(compact.length() <= ((maxBytes + 2) / 3) * 4, "base64_size");
        byte[] bytes = Base64.getDecoder().decode(compact.toString());
        require(bytes.length <= maxBytes, "base64_size");
        return bytes;
    }

    private static void require(boolean valid, String reason) {
        if (!valid) throw new IllegalArgumentException(reason);
    }

    /** One assembler belongs to one binding generation. All access must be serialized. */
    public static final class Payload {
        public static final long TRANSFER_TTL_MS = 10000;
        public static final int MAX_CHUNKS = 128;
        public static final int MAX_CHUNK_BYTES = 32768;
        public static final int MAX_TRANSFERS = 2;
        private final Map<String, Transfer> transfers = new LinkedHashMap<String, Transfer>();
        private long outputReceivedAt = -1;

        public synchronized void clear() { transfers.clear(); outputReceivedAt = -1; }
        public synchronized int activeTransfers() { return transfers.size(); }
        /** Earliest receipt belonging to the last completed value; -1 for an incomplete transfer. */
        public synchronized long outputReceivedElapsedMs() { return outputReceivedAt; }

        public synchronized String accept(String raw, long nowMs) throws Exception {
            return accept(raw, nowMs, nowMs);
        }

        public synchronized String accept(String raw, long nowMs, long receivedMs) throws Exception {
            outputReceivedAt = -1;
            require(raw != null && raw.length() <= MAX_WIRE_CHARS, "payload_size");
            expire(nowMs);
            String trimmed = raw.trim();
            if (trimmed.isEmpty() || trimmed.charAt(0) != '{') {
                outputReceivedAt = receivedMs;
                return raw;
            }
            JSONObject control;
            try { control = jsonObject(trimmed); }
            catch (Exception nonJson) { outputReceivedAt = receivedMs; return raw; }
            Object kindValue = control.opt("type");
            if (!(kindValue instanceof String)) { outputReceivedAt = receivedMs; return raw; }
            String kind = (String) kindValue;
            if (!"begin_transfer".equals(kind) && !"chunk_data".equals(kind)
                    && !"end_transfer".equals(kind)) { outputReceivedAt = receivedMs; return raw; }
            Object idValue = control.opt("transferId");
            require(idValue instanceof String, "transfer_id");
            String id = (String) idValue;
            require(!id.isEmpty() && id.length() <= 100, "transfer_id");
            try {
                if ("begin_transfer".equals(kind)) {
                    Object size = control.has("totalSize") ? control.opt("totalSize")
                            : control.opt("total_size");
                    Object count = control.opt("totalChunks");
                    require(isInteger(size, 1, MAX_FRAME_BYTES), "transfer_size");
                    require(isInteger(count, 1, MAX_CHUNKS), "transfer_chunks");
                    int expected = ((Number) size).intValue();
                    int chunks = ((Number) count).intValue();
                    require(expected <= (long) chunks * MAX_CHUNK_BYTES, "transfer_capacity");
                    Transfer prior = transfers.get(id);
                    if (prior != null) {
                        require(prior.expectedBytes == expected && prior.parts.length == chunks,
                                "transfer_redefined");
                    } else {
                        require(transfers.size() < MAX_TRANSFERS, "transfer_capacity");
                        transfers.put(id, new Transfer(expected, chunks, nowMs, receivedMs));
                    }
                    return null;
                }
                Transfer transfer = transfers.get(id);
                require(transfer != null, "unknown_transfer");
                if ("chunk_data".equals(kind)) {
                    Object index = control.opt("chunkIndex");
                    Object encoded = control.opt("data");
                    require(isInteger(index, 0, transfer.parts.length - 1), "chunk_index");
                    require(encoded instanceof String && ((String) encoded).length() <= 65536,
                            "chunk_data");
                    byte[] bytes = base64((String) encoded, MAX_CHUNK_BYTES);
                    require(bytes.length > 0, "empty_chunk");
                    int part = ((Number) index).intValue();
                    byte[] prior = transfer.parts[part];
                    if (prior != null) require(Arrays.equals(prior, bytes), "conflicting_chunk");
                    else {
                        require((long) transfer.receivedBytes + bytes.length <= transfer.expectedBytes,
                                "transfer_overflow");
                        transfer.parts[part] = bytes;
                        transfer.receivedBytes += bytes.length;
                        transfer.receivedParts++;
                    }
                    return null;
                }
                transfers.remove(id);
                require("success".equals(control.opt("status")), "transfer_failed");
                require(transfer.receivedParts == transfer.parts.length
                        && transfer.receivedBytes == transfer.expectedBytes, "transfer_incomplete");
                ByteArrayOutputStream buffer = new ByteArrayOutputStream(transfer.expectedBytes);
                for (byte[] part : transfer.parts) buffer.write(part, 0, part.length);
                String completed = utf8(buffer.toByteArray());
                outputReceivedAt = transfer.receivedAt;
                return completed;
            } catch (Exception malformed) {
                transfers.remove(id);
                throw malformed;
            }
        }

        private void expire(long nowMs) {
            Iterator<Transfer> iterator = transfers.values().iterator();
            while (iterator.hasNext()) {
                long age = nowMs - iterator.next().startedAt;
                if (age < 0 || age > TRANSFER_TTL_MS) iterator.remove();
            }
        }

        private static final class Transfer {
            final int expectedBytes;
            final byte[][] parts;
            final long startedAt;
            final long receivedAt;
            int receivedBytes;
            int receivedParts;
            Transfer(int size, int chunks, long nowMs, long receivedMs) {
                expectedBytes = size;
                parts = new byte[chunks][];
                startedAt = nowMs;
                receivedAt = receivedMs;
            }
        }
    }
}
