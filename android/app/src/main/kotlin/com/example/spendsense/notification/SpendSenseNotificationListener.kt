package com.example.spendsense.notification

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import com.example.spendsense.notification.parser.NotificationParser
import com.example.spendsense.notification.filter.NotificationFilter
import com.example.spendsense.notification.detector.PaymentDetector
import com.example.spendsense.notification.bridge.NotificationBridge

class SpendSenseNotificationListener : NotificationListenerService() {

    companion object {
        private const val TAG = "SpendSenseListener"
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)

        if (sbn == null) return

        val extras = sbn.notification.extras

        val notification = NotificationParser.parse(sbn)
        if (!NotificationFilter.isSupported(notification)) {
            return
        }

        val transaction = PaymentDetector.detect(notification)
        Log.d(TAG, "Detected Transaction: $transaction")

        if (transaction == null) {
            return
        }

        NotificationBridge.publish(notification)

        Log.d(TAG, "==============================")
        Log.d(TAG, "Package : ${notification.packageName}")
        Log.d(TAG, "Title   : ${notification.title}")
        Log.d(TAG, "Text    : ${notification.text}")
        Log.d(TAG, "Time    : ${notification.timestamp}")
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        super.onNotificationRemoved(sbn)

        if (sbn == null) return

        Log.d(TAG, "Removed notification from ${sbn.packageName}")
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.d(TAG, "Notification Listener Connected!")
    }
}