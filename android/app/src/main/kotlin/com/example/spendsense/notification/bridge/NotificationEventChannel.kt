package com.example.spendsense.notification.bridge

import io.flutter.plugin.common.EventChannel

object NotificationEventChannel : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun send(data: Map<String, Any?>) {
        eventSink?.success(data)
    }
}