package com.freshplanet.ane.AirDeviceId.functions;

import android.os.Build;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class GetVersionFunction implements FREFunction
{

    @Override
    public FREObject call(FREContext ctx, FREObject[] args) {
        String version = getOSVersion();
        FREObject versionObj = null;
        try {
            versionObj = FREObject.newObject(version);
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        }
        return versionObj;
    }

    private String getOSVersion()
    {
        return Build.VERSION.RELEASE;
    }
}
