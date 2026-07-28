package com.example.spendsense.notification

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import com.example.spendsense.location.CurrentLocationCache
import com.example.spendsense.notification.bridge.NotificationBridge
import com.example.spendsense.notification.detector.PaymentDetector
import com.example.spendsense.notification.domain.DetectedTransaction
import com.example.spendsense.notification.domain.TransactionType
import com.example.spendsense.notification.filter.NotificationFilter
import com.example.spendsense.notification.parser.NotificationParser
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

        Log.d(TAG, "==============================")
        Log.d(TAG, "Package : ${notification.packageName}")
        Log.d(TAG, "Title   : ${notification.title}")
        Log.d(TAG, "Text    : ${notification.text}")

        if (!NotificationFilter.isSupported(notification)) {
            Log.d(TAG, "Filtered out")
            return
        }

        val detected = PaymentDetector.detect(notification)

        if (detected == null) {
            Log.d(TAG, "PaymentDetector returned null")
            return
        }

        if (detected.type != TransactionType.INCOME) {
            Log.d(TAG, "Ignoring expense notification")
            return
        }

        val transaction = detected.copy(
            notificationId = sbn.key
        )

        Log.d(TAG, "Detected Transaction: $transaction")

        // Read the latest cached location
        publishTransaction(
    transaction,
    null,
    null
)

        Log.d(TAG, "==============================")
        Log.d(TAG, "Package : ${notification.packageName}")
        Log.d(TAG, "Merchant: ${transaction.merchant}")
        Log.d(TAG, "Time    : ${transaction.timestamp}")
    }

    private fun publishTransaction(
        transaction: DetectedTransaction,
        latitude: Double?,
        longitude: Double?
    ) {

        val json = JSONObject().apply {
            put("notificationId", transaction.notificationId)
            put("amount", transaction.amount)
            put("type", transaction.type.name)
            put("sourceApp", transaction.sourceApp)
            put("merchant", transaction.merchant)
            put("timestamp", transaction.timestamp)
            put("latitude", latitude)
            put("longitude", longitude)
        }

        PendingTransactionQueue.enqueue(
            applicationContext,
            json
        )

        NotificationBridge.publish(
            transaction.copy(
                latitude = latitude,
                longitude = longitude
            )
        )

        Log.d(
            TAG,
            "Published transaction with location: lat=$latitude lon=$longitude"
        )
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        super.onNotificationRemoved(sbn)

        if (sbn == null) return

        Log.d(
            TAG,
            "Removed notification from ${sbn.packageName}"
        )
    }

    override fun onListenerConnected() {
        super.onListenerConnected()

        Log.d(
            TAG,
            "Notification Listener Connected!"
        )
    }
}