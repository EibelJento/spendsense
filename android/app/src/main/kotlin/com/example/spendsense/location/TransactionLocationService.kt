package com.example.spendsense.location

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.example.spendsense.R
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import android.os.Handler
import android.os.Looper

class TransactionLocationService : Service() {

    companion object {
        private const val CHANNEL_ID = "transaction_location"
        private const val NOTIFICATION_ID = 2001
    }

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private lateinit var requestId: String
    private val handler = Handler(Looper.getMainLooper())

private var bestLocation: android.location.Location? = null

private val timeoutRunnable = Runnable {
    android.util.Log.d("TxnLocation", "Timeout")


    if (bestLocation != null) {

        TransactionLocationManager.deliverLocation(
            requestId,
            bestLocation!!.latitude,
            bestLocation!!.longitude
        )

    } else {

        TransactionLocationManager.deliverLocation(
            requestId,
            null,
            null
        )
    }

    if (::locationCallback.isInitialized) {
        fusedLocationClient.removeLocationUpdates(locationCallback)
    }

    stopSelf()
}

    override fun onCreate() {
        super.onCreate()
        android.util.Log.d("TxnLocation", "onCreate")

        fusedLocationClient =
            LocationServices.getFusedLocationProviderClient(this)

        createNotificationChannel()

        startForeground(
            NOTIFICATION_ID,
            buildNotification()
        )
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        android.util.Log.d("TxnLocation", "onStartCommand")

        requestId = intent?.getStringExtra("requestId")
            ?: run {
                android.util.Log.d("TxnLocation", "No requestId")
                stopSelf()
                return START_NOT_STICKY
            }

        android.util.Log.d("TxnLocation", "requestId=$requestId")
        requestLocation()

        return START_NOT_STICKY
    }

    private fun requestLocation() {
        android.util.Log.d("TxnLocation", "requestLocation")

        if (
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {

            TransactionLocationManager.deliverLocation(
                requestId,
                null,
                null
            )

            stopSelf()
            return
        }
        android.util.Log.d("TxnLocation", "Permission granted")

        val request =
            LocationRequest.Builder(
                Priority.PRIORITY_HIGH_ACCURACY,
                1000L
            )
                .setWaitForAccurateLocation(true)
                .build()

        locationCallback =
            object : LocationCallback() {

            override fun onLocationResult(result: LocationResult) {

    val location = result.lastLocation ?: return

    android.util.Log.d(
        "TxnLocation",
        "Location ${location.latitude}, ${location.longitude}, accuracy=${location.accuracy}"
    )

    if (
        bestLocation == null ||
        location.accuracy < bestLocation!!.accuracy
    ) {
        bestLocation = location
    }

    if (location.accuracy <= 25f) {

        handler.removeCallbacks(timeoutRunnable)

        TransactionLocationManager.deliverLocation(
            requestId,
            location.latitude,
            location.longitude
        )

        fusedLocationClient.removeLocationUpdates(this)

        stopSelf()
    }
}
            }

        try {

            fusedLocationClient.requestLocationUpdates(
                request,
                locationCallback,
                mainLooper
            )
            android.util.Log.d("TxnLocation", "Waiting for GPS...")
            handler.postDelayed(
    timeoutRunnable,
    10_000L
)

        } catch (e: SecurityException) {

            TransactionLocationManager.deliverLocation(
                requestId,
                null,
                null
            )

            stopSelf()
        }
    }

    override fun onDestroy() {

    handler.removeCallbacks(timeoutRunnable)

    if (::locationCallback.isInitialized) {
        fusedLocationClient.removeLocationUpdates(locationCallback)
    }

    super.onDestroy()
}

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val channel = NotificationChannel(
                CHANNEL_ID,
                "Transaction Location",
                NotificationManager.IMPORTANCE_LOW
            )

            val manager =
                getSystemService(NotificationManager::class.java)

            manager.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(): Notification {

        return NotificationCompat.Builder(
            this,
            CHANNEL_ID
        )
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("SpendSense")
            .setContentText("Getting transaction location")
            .setOngoing(true)
            .build()
    }
}