package com.example.spendsense.location

import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat

object ContinuousLocationManager {

    private const val PREFS = "spendsense_prefs"
    private const val KEY_ENABLED = "continuous_location_enabled"

    fun enable(context: Context) {

        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .putBoolean(KEY_ENABLED, true)
            .apply()

        val intent = Intent(
            context,
            ContinuousLocationService::class.java
        )

        ContextCompat.startForegroundService(
            context,
            intent
        )
    }

    fun disable(context: Context) {

        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .putBoolean(KEY_ENABLED, false)
            .apply()

        val intent = Intent(
            context,
            ContinuousLocationService::class.java
        )

        context.stopService(intent)

        CurrentLocationCache.clear()
    }

    fun isEnabled(context: Context): Boolean {
        return context
            .getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .getBoolean(KEY_ENABLED, false)
    }
}