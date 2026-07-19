package com.example.spendsense.notification.parser

import android.service.notification.StatusBarNotification
import com.example.spendsense.notification.domain.RawNotification

object NotificationParser {

    fun parse(sbn: StatusBarNotification): RawNotification {

        val extras = sbn.notification.extras

        return RawNotification(
            packageName = sbn.packageName,
            title = extras.getCharSequence("android.title")?.toString(),
            text = extras.getCharSequence("android.text")?.toString(),
            timestamp = sbn.postTime
        )
    }
}