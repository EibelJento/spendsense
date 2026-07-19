package com.example.spendsense.notification.bridge

import android.util.Log
import com.example.spendsense.notification.domain.RawNotification

object NotificationBridge {

    private const val TAG = "NotificationBridge"

    fun publish(notification: RawNotification) {
        Log.d(TAG, "Publishing: $notification")
    }
}