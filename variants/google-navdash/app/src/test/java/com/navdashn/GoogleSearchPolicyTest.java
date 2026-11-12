package com.navdashn;

import com.google.android.libraries.places.api.model.Place;
import org.junit.Test;
import static org.junit.Assert.*;

/** Billing-sensitive field selection and user-facing error/selection regression tests. */
public final class GoogleSearchPolicyTest {
    @Test public void requestsOnlyIdentityAndCoordinates() {
        assertEquals(2, GoogleSearchPolicy.detailsFields().size());
        assertTrue(GoogleSearchPolicy.detailsFields().contains(Place.Field.ID));
        assertTrue(GoogleSearchPolicy.detailsFields().contains(Place.Field.LAT_LNG));
        assertFalse(GoogleSearchPolicy.detailsFields().contains(Place.Field.NAME));
        assertFalse(GoogleSearchPolicy.detailsFields().contains(Place.Field.ADDRESS));
    }

    @Test public void selectedPredictionSuppliesNavigationLabels() {
        String name = GoogleSearchPolicy.title(" 台北車站 ", " 台北市中正區北平西路3號 ");
        String address = GoogleSearchPolicy.address(" 台北市中正區北平西路3號 ");
        assertEquals("台北車站", name);
        assertEquals("台北市中正區北平西路3號", address);
        assertEquals("台北市中正區", GoogleSearchPolicy.title("", "台北市中正區"));
        assertEquals("已選目的地", GoogleSearchPolicy.title(null, null));
        assertEquals("", GoogleSearchPolicy.address(null));
    }

    @Test public void quotaIsNotReportedAsOffline() {
        assertTrue(GoogleSearchPolicy.errorMessage(9010).contains("配額"));
        assertFalse(GoogleSearchPolicy.errorMessage(9010).contains("沒有網路"));
        assertTrue(GoogleSearchPolicy.errorMessage(9011).contains("SHA-1"));
        assertTrue(GoogleSearchPolicy.errorMessage(9012).contains("無效"));
        assertTrue(GoogleSearchPolicy.errorMessage(9013).contains("找不到"));
        assertTrue(GoogleSearchPolicy.errorMessage(7).contains("網路"));
        assertTrue(GoogleSearchPolicy.errorMessage(999).contains("999"));
        assertFalse(GoogleSearchPolicy.errorMessage(-1).contains("-1"));
    }

    @Test public void duplicateQueriesAreBoundedWithoutBlockingNewQueries() {
        assertFalse(GoogleSearchPolicy.shouldRequest("台", "", 1000, -1));
        assertTrue(GoogleSearchPolicy.shouldRequest("台北", "", 1000, -1));
        assertFalse(GoogleSearchPolicy.shouldRequest("台北", "台北", 1500, 1000));
        assertTrue(GoogleSearchPolicy.shouldRequest("台北車站", "台北", 1500, 1000));
        assertTrue(GoogleSearchPolicy.shouldRequest("台北", "台北", 2000, 1000));
        assertTrue(GoogleSearchPolicy.shouldRequest("台北", "台北", 500, 1000));
    }
}
