package com.example.spendsense.notification.domain

data class DetectedTransaction(
    val notificationId: String,
    val amount: Double,
    val type: TransactionType,
    val sourceApp: String,
    val merchant: String?,
    val timestamp: Long
)