package com.navipilot.obf;
import java.net.URLDecoder;
import java.util.Iterator;
import java.util.Locale;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

/** Bounded copy of authorized navigation JSON for opt-in local analysis, never control. */
public final class WideAmapLinkTrace {
    private static final int MAX_INPUT = 4 * 1024 * 1024;
    private int nodes, chars, redacted;
    private boolean truncated;
    private WideAmapLinkTrace() { }
    public static JSONObject capture(String text) {
        WideAmapLinkTrace copier = new WideAmapLinkTrace();
        JSONObject out = new JSONObject();
        try {
            out.put("schema", 1).put("control_input", false).put("raw_bytes_preserved", false)
                    .put("input_chars", text == null ? 0 : text.length());
            if (text == null || text.length() > MAX_INPUT) {
                out.put("parse_status", "missing_or_oversize");
                copier.truncated = true;
            } else {
                Object value = parse(text);
                if (!(value instanceof JSONObject) && !(value instanceof JSONArray))
                    throw new IllegalArgumentException("structured_value_required");
                out.put("payload", copier.copy(value, "", 0)).put("parse_status", "decoded");
            }
        } catch (Exception invalid) {
            try { out.put("parse_status", "unparsed"); } catch (Exception ignored) { }
        }
        try { out.put("truncated", copier.truncated).put("redacted_fields", copier.redacted)
                .put("visited_nodes", copier.nodes); } catch (Exception ignored) { }
        return out;
    }
    private Object copy(Object value, String key, int depth) throws Exception {
        if (++nodes > 12000 || chars >= 180000 || depth > 20) {
            truncated = true; return "[capture_limit]";
        }
        String k = key.toLowerCase(Locale.ROOT).replace("_", "").replace("-", "");
        if (k.matches(".*(token|secret|password|signature|cookie|authorization|apikey|aeskey|sessionid).*")
                || k.matches("key|nonce|iv|uid|userid|accountid|email|phone|phonenumber")) {
            redacted++; return "[redacted]";
        }
        if (value == null || value == JSONObject.NULL) return JSONObject.NULL;
        if (value instanceof JSONObject) {
            JSONObject input = (JSONObject) value, result = new JSONObject();
            Iterator<String> keys = input.keys(); int count = 0;
            while (keys.hasNext()) {
                String name = keys.next();
                if (++count > 256 || name.length() > 128 || nodes >= 12000 || chars >= 180000) {
                    truncated = true; break;
                }
                chars += name.length();
                result.put(name, copy(input.opt(name), name, depth + 1));
            }
            return result;
        }
        if (value instanceof JSONArray) {
            JSONArray input = (JSONArray) value, result = new JSONArray();
            for (int i = 0; i < input.length(); i++) {
                if (i >= 4096 || nodes >= 12000 || chars >= 180000) { truncated = true; break; }
                result.put(copy(input.opt(i), key, depth + 1));
            }
            return result;
        }
        if (value instanceof Number || value instanceof Boolean) { chars += 24; return value; }
        if (!(value instanceof String)) { redacted++; return "[unsupported_value]"; }
        String text = ((String) value).trim(), lower = text.toLowerCase(Locale.ROOT);
        boolean encoded = lower.startsWith("%7b") || lower.startsWith("%5b") || lower.startsWith("%22");
        if (encoded || text.startsWith("{") || text.startsWith("[") || text.startsWith("\"")) {
            if (text.length() <= MAX_INPUT && depth < 20) {
                try {
                    if (encoded) text = URLDecoder.decode(text.replace("+", "%2B"), "UTF-8");
                    return copy(parse(text), key, depth + 1);
                } catch (Exception invalid) { }
            } else truncated = true;
        }
        if (k.matches("nextroadname|nextroutename|curroadname|roadname")) {
            if (text.length() > 200) { text = text.substring(0, 200); truncated = true; }
            chars += text.length(); return text.replaceAll("[\\p{Cntrl}]", " ");
        }
        if (k.equals("status") && (text.equals("success") || text.equals("error"))) {
            chars += text.length(); return text;
        }
        redacted++; chars += 32;
        return new JSONObject().put("_string_chars", text.length());
    }
    private static Object parse(String text) throws Exception {
        int depth = 0; char quote = 0; boolean escaped = false;
        for (int i = 0; i < text.length(); i++) {
            char ch = text.charAt(i);
            if (quote != 0) {
                if (escaped) escaped = false;
                else if (ch == '\\') escaped = true;
                else if (ch == quote) quote = 0;
            } else if (ch == '"' || ch == '\'') quote = ch;
            else if (ch == '{' || ch == '[') {
                if (++depth > 64) throw new IllegalArgumentException("depth");
            } else if (ch == '}' || ch == ']') depth--;
        }
        JSONTokener parser = new JSONTokener(text);
        Object result = parser.nextValue();
        if (parser.nextClean() != 0) throw new IllegalArgumentException("trailing");
        return result;
    }
}

