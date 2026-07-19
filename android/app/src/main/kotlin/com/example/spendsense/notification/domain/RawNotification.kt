package com.example.spendsense.notification.domain

data class RawNotification(
    val packageName: String,
    val title: String?,
    val text: String?,
    val timestamp: Long
)