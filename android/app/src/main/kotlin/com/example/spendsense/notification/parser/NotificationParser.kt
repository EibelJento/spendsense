package com.example.spendsense.notification.parser

import android.app.Notification
import android.service.notification.StatusBarNotification
import com.example.spendsense.notification.domain.RawNotification

object NotificationParser {

    fun parse(sbn: StatusBarNotification): RawNotification {

        val extras = sbn.notification.extras
        extras.keySet().forEach {
    android.util.Log.d("NotificationParser", "$it = ${extras.get(it)}")
}

        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString()

        val text = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()
            ?: extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()

        return RawNotification(
            packageName = sbn.packageName,
            title = title,
            text = text,
            timestamp = sbn.postTime
        )
    }
}