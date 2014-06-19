package com.freshplanet.ane.AirDeviceId.functions;

import android.util.Log;

import android.os.Build;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class GetModelFunction implements FREFunction
{

    private static String TAG = "[AirDeviceId] GetModelFunction -";

    @Override
    public FREObject call(FREContext ctx, FREObject[] args)
    {
        String modelStr = getDeviceModel();
        
        Log.d(TAG, "Model=("+modelStr+")");
        
        FREObject modelObj = null;
        try
        {
            modelObj = FREObject.newObject(modelStr);
        }
        catch (FREWrongThreadException e)
        {
            e.printStackTrace();
        }
        return modelObj;
    }

    /** Get the device model (incl. manufacturer) in format: 'Manufacturer MODEL' */
    private String getDeviceModel()
    {
        String manufacturer = Build.MANUFACTURER;
        String model = Build.MODEL;

        if (model.startsWith(manufacturer))
        {
            return  capitalize(model);
        }
        else
        {
            return  capitalize(manufacturer) + " " + model;
        }
    }

    /** Capitalize the passed String */
    private String capitalize(String s)
    {
        // nothing to work with
        if (s == null || s.length() == 0)
        {
            return "";
        }
        char first = s.charAt(0);
        if (Character.isUpperCase(first))
        {
            return s;
        }
        else
        {
            return Character.toUpperCase(first) + s.substring(1);
        }
    }
}
