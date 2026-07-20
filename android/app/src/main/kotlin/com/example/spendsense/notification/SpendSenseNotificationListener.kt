package com.example.spendsense.notification

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import com.example.spendsense.notification.parser.NotificationParser
import com.example.spendsense.notification.filter.NotificationFilter
import com.example.spendsense.notification.detector.PaymentDetector
import com.example.spendsense.notification.bridge.NotificationBridge
import com.example.spendsense.notification.queue.PendingTransactionQueue
import org.json.JSONObject

class SpendSenseNotificationListener : NotificationListenerService() {

    companion object {
        private const val TAG = "SpendSenseListener"
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)

        if (sbn == null) return

        val notification = NotificationParser.parse(sbn)
        if (!NotificationFilter.isSupported(notification)) {
            return
        }

        val detected = PaymentDetector.detect(notification)

if (detected == null) {
    return
}

val transaction = detected.copy(
    notificationId = sbn.key
)

Log.d(TAG, "Detected Transaction: $transaction")

        val json = JSONObject().apply {
        put("notificationId", transaction.notificationId)
        put("amount", transaction.amount)
        put("type", transaction.type.name)
        put("sourceApp", transaction.sourceApp)
        put("merchant", transaction.merchant)
        put("timestamp", transaction.timestamp)
        }

    PendingTransactionQueue.enqueue(this, json)

    NotificationBridge.publish(transaction)

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