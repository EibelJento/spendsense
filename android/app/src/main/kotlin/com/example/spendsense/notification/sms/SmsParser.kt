package com.example.spendsense.notification.sms

import com.example.spendsense.notification.domain.RawNotification

object SmsParser {

    fun parse(sender: String?, body: String): RawNotification {

        return RawNotification(
            packageName = "SMS",
            title = sender,
            text = body,
            timestamp = System.currentTimeMillis()
        )
    }
}