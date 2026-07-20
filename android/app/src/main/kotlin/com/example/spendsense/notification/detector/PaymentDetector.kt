package com.example.spendsense.notification.detector

import com.example.spendsense.notification.domain.DetectedTransaction
import com.example.spendsense.notification.domain.RawNotification
import com.example.spendsense.notification.domain.TransactionType
import com.example.spendsense.notification.extractor.AmountExtractor
import com.example.spendsense.notification.extractor.MerchantExtractor

object PaymentDetector {

    fun detect(notification: RawNotification): DetectedTransaction? {

        val content = "${notification.title} ${notification.text}".lowercase()

        val type = when {

            // -------- Income --------
            content.contains("paid you") -> TransactionType.INCOME
            content.contains("received") -> TransactionType.INCOME
            content.contains("credited") -> TransactionType.INCOME
            content.contains("received from") -> TransactionType.INCOME

            // -------- Expense --------
            content.contains("you paid") -> TransactionType.EXPENSE
            content.contains("paid to") -> TransactionType.EXPENSE
            content.contains("sent") -> TransactionType.EXPENSE
            content.contains("debited") -> TransactionType.EXPENSE
            content.contains("payment successful") -> TransactionType.EXPENSE

            else -> return null
        }

        val amount = AmountExtractor.extract(notification) ?: return null
        val merchant = MerchantExtractor.extract(notification)

        return DetectedTransaction(
            notificationId = "",
            amount = amount,
            type = type,
            sourceApp = notification.packageName,
            merchant = merchant,
            timestamp = notification.timestamp
        )
    }

}