package com.example.spendsense.notification.sms

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.util.Log
import com.example.spendsense.location.CurrentLocationCache
import com.example.spendsense.notification.bridge.NotificationBridge
import com.example.spendsense.notification.detector.PaymentDetector
import com.example.spendsense.notification.domain.DetectedTransaction
import com.example.spendsense.notification.domain.TransactionType
import com.example.spendsense.notification.queue.PendingTransactionQueue
import org.json.JSONObject

class SmsReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "SpendSenseSMS"
    }

    override fun onReceive(context: Context, intent: Intent?) {

        if (intent?.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            return
        }

        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)

        val body = buildString {
            messages.forEach { append(it.messageBody) }
        }

        val sender = messages.firstOrNull()?.originatingAddress

        val notification = SmsParser.parse(sender, body)

        val detected = PaymentDetector.detect(notification)

        if (detected == null) {
            Log.d(TAG, "Not a transaction SMS")
            return
        }

        if (detected.type != TransactionType.EXPENSE) {
            Log.d(TAG, "Ignoring income SMS")
            return
        }

        val notificationId = "SMS_${sender}_${body.hashCode()}"

        val transaction = detected.copy(
            notificationId = notificationId
        )

        Log.d(TAG, "Detected SMS Transaction: $transaction")

        // Read the latest cached location
        val latitude = CurrentLocationCache.latitude
        val longitude = CurrentLocationCache.longitude

        publishTransaction(
            context.applicationContext,
            transaction,
            latitude,
            longitude
        )
    }

    private fun publishTransaction(
        context: Context,
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
            context,
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
            "Saved SMS Transaction: ${transaction.notificationId}"
        )

        Log.d(
            TAG,
            "Location = ($latitude, $longitude)"
        )
    }
}