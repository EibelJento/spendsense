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
import com.google.android.gms.location.*

class ContinuousLocationService : Service() {

    companion object {
        private const val CHANNEL_ID = "continuous_location"
        private const val NOTIFICATION_ID = 3001
    }

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback

    override fun onCreate() {
        super.onCreate()

        fusedLocationClient =
            LocationServices.getFusedLocationProviderClient(this)

        createNotificationChannel()

        startForeground(
            NOTIFICATION_ID,
            buildNotification()
        )

        startLocationUpdates()
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        return START_STICKY
    }

    private fun startLocationUpdates() {

        if (
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            stopSelf()
            return
        }

        val request =
            LocationRequest.Builder(
                Priority.PRIORITY_HIGH_ACCURACY,
                5000L
            )
                .setMinUpdateIntervalMillis(2000L)
                .setWaitForAccurateLocation(false)
                .build()

        locationCallback =
            object : LocationCallback() {

                override fun onLocationResult(
                    result: LocationResult
                ) {

                    val location =
                        result.lastLocation ?: return

                    CurrentLocationCache.update(
                        latitude = location.latitude,
                        longitude = location.longitude,
                        accuracy = location.accuracy
                    )

                    android.util.Log.d(
                        "ContinuousLocation",
                        "Updated: ${location.latitude}, ${location.longitude}, accuracy=${location.accuracy}"
                    )
                }
            }

        fusedLocationClient.requestLocationUpdates(
            request,
            locationCallback,
            mainLooper
        )
    }

    override fun onDestroy() {

        if (::locationCallback.isInitialized) {
            fusedLocationClient.removeLocationUpdates(locationCallback)
        }

        CurrentLocationCache.clear()

        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val channel = NotificationChannel(
                CHANNEL_ID,
                "Continuous Location Tracking",
                NotificationManager.IMPORTANCE_LOW
            )

            getSystemService(
                NotificationManager::class.java
            ).createNotificationChannel(channel)
        }
    }

    private fun buildNotification(): Notification {

        return NotificationCompat.Builder(
            this,
            CHANNEL_ID
        )
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("SpendSense")
            .setContentText("Tracking location for transactions")
            .setOngoing(true)
            .build()
    }
}