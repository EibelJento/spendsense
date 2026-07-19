package com.example.spendsense.notification.filter

import com.example.spendsense.notification.domain.RawNotification

object NotificationFilter {

    fun isSupported(notification: RawNotification): Boolean {
        return notification.packageName in SupportedApps.paymentApps
    }
}