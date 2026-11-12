package com.navipilot.obf;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import org.json.*;
public final class CatalogTest {
    static void require(boolean b,String message) { if(!b) throw new AssertionError(message); }
    public static void main(String[] args) throws Exception {
        String input=new String(Files.readAllBytes(Paths.get(args[0])),StandardCharsets.UTF_8);
        WideEnforcementCatalog catalog=new WideEnforcementCatalog(input);
        JSONObject root=new JSONObject(input);JSONArray rows=root.getJSONArray("records");int checked=0;
        for(int i=0;i<rows.length();i++) {
            JSONObject r=rows.getJSONObject(i);if(r.isNull("coordinates"))continue;
            JSONArray p=r.getJSONArray("coordinates");
            List<WideEnforcementCatalog.Site> near=catalog.nearby(p.getDouble(1),p.getDouble(0),1,null,"2099-01-01");
            boolean found=false;
            for(WideEnforcementCatalog.Site s:near){require(!s.preciseAlertReady(),"no road binding cannot mean precise alert");if(s.record.getString("id").equals(r.getString("id")))found=true;}
            require(found,"spatial index missed "+r.getString("id"));checked++;
        }
        require(catalog.nearby(26.9,122.9,1,null,"2026-11-12").isEmpty(),"empty ocean query");
        try {catalog.nearby(Double.NaN,121,1000,null,"2026-11-12");throw new AssertionError("NaN accepted");}catch(IllegalArgumentException expected){}
        // Synthetic points at a grid edge exercise neighboring cells, future suppression and heading wrap.
        String synthetic="{\"schemaVersion\":1,\"tileDegrees\":0.01,\"records\":[{\"id\":\"a\",\"coordinates\":[121.01,25],\"travelBearing\":0,\"activationDate\":\"2030-01-01\"}],\"tiles\":{\"12101:2500\":[0]}}";
        WideEnforcementCatalog test=new WideEnforcementCatalog(synthetic);
        require(test.nearby(25,121.00999,100,359.0,"2026-11-12").isEmpty(),"future point alerted");
        List<WideEnforcementCatalog.Site> a=test.nearby(25,121.00999,100,359.0,"2031-01-01");
        require(a.size()==1&&!a.get(0).oppositeDirection,"boundary/wrap");
        require(test.nearby(25,121.00999,100,180.0,"2031-01-01").get(0).oppositeDirection,"reverse direction");
        System.out.println("PASS: "+checked+" located records spatially reachable; future date, reverse/wrapped heading, grid boundary, invalid GPS and no-road-match checks");
    }
}
