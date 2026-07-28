package com.example.spendsense.location

import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import java.util.UUID
import java.util.concurrent.ConcurrentHashMap

object TransactionLocationManager {

    private val callbacks =
        ConcurrentHashMap<String, (Double?, Double?) -> Unit>()

    fun requestLocation(
        context: Context,
        onResult: (Double?, Double?) -> Unit
    ) {

        val requestId = UUID.randomUUID().toString()

        callbacks[requestId] = onResult

        val intent = Intent(
            context,
            TransactionLocationService::class.java
        ).apply {
            putExtra("requestId", requestId)
        }

        ContextCompat.startForegroundService(
            context,
            intent
        )
    }

    internal fun deliverLocation(
        requestId: String,
        latitude: Double?,
        longitude: Double?
    ) {

        callbacks.remove(requestId)
            ?.invoke(latitude, longitude)
    }
}