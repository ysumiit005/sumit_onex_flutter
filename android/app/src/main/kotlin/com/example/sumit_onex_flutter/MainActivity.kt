package com.example.sumit_onex_flutter



import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.wifi.ScanResult
import android.net.wifi.WifiManager
import android.os.BatteryManager
import android.os.Build
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        //
        //
        //
        // FLUTTER Channel (most imp point to connect flutter and native code)
        //
        //
        //
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {


            // This method is invoked on the main thread.
            call, result ->
            if (call.method == "getBatteryLevel") {
                println("battery level test");
                val value = getBatteryLevel();
                if (value != -1) {
                    result.success(50)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }

            }

            // try get wifi list and show
            if (call.method == "getWifiList") {
                println("yepee wifi list");

               val value = getWifiList();
      
            //    connectToWifi(context, "OrageDigital", "Offee9821") // my code not working
            //    connect("OrageDigital", "Offee9821") //priyanshu sir code - works on few old mobiles but not on new
                try {
                    result.success(value.toString())
                 } catch (e: Exception) {
                 // Suppress the error
                 println("Custom Supressed Error as solution found on github to supress it ")
                 }
            }

            // get wifi settings modal from below
            if (call.method == "getOnlyWifiSettingFromBottom") {

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    val panelIntent = Intent(Settings.Panel.ACTION_WIFI)
                    startActivityForResult(panelIntent, 545)
                } else {

                    startActivity(Intent(WifiManager.ACTION_PICK_WIFI_NETWORK));

                }

            }

            // get wifi settings modal from below with also option of mobile net
            if (call.method == "getWifiAndMobileNetSettingFromBottom") {
                

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    val panelIntent = Intent(Settings.Panel.ACTION_INTERNET_CONNECTIVITY)
                    startActivityForResult(panelIntent, 545)
                } else {

                    startActivity(Intent(WifiManager.ACTION_PICK_WIFI_NETWORK));

                }

            }

        }

    } // end of flutter engine

    //
    //
    //  only functions below
    //
    //

    //
    //
    // get battery level
    //
    //
    fun getBatteryLevel(): Int {

        val batteryLevel: Int

        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }


    //
    //
    // get wifi list and display
    //
    //
    fun getWifiList(): List<ScanResult> {

        var wifiScanList: List<ScanResult>
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            //
            var wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
            
            // get all wifi list mobile is able to find even though not connected to wifi
            wifiScanList = wifiManager.scanResults
           
            if (ContextCompat.checkSelfPermission(
                            context,
                            android.Manifest.permission.ACCESS_COARSE_LOCATION
                    ) != PackageManager.PERMISSION_GRANTED
            ) {
                println("Not having permission")
            } else {
                
                println("This is the list")
                println(wifiScanList)
                println("in kotlin")

            }
            

            return wifiScanList 

        } else {
            return emptyList()
        }

    }



}

