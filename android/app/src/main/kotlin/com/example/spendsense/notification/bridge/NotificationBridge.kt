package com.example.spendsense.notification.bridge

import com.example.spendsense.notification.domain.DetectedTransaction

object NotificationBridge {

    fun publish(transaction: DetectedTransaction) {

        NotificationEventChannel.send(
            mapOf(
                "notificationId" to transaction.notificationId,
                "amount" to transaction.amount,
                "type" to transaction.type.name,
                "sourceApp" to transaction.sourceApp,
                "merchant" to transaction.merchant,
                "timestamp" to transaction.timestamp
            )
        )
    }
}