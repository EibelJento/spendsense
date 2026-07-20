package com.example.spendsense.notification.bridge

import android.content.Context
import com.example.spendsense.notification.queue.PendingTransactionQueue
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

class NotificationMethodChannel(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {

            "getPendingTransactions" -> {

                val queue = PendingTransactionQueue.getAll(context)

                val list = mutableListOf<Map<String, Any?>>()

                for (i in 0 until queue.length()) {

                    val obj = queue.getJSONObject(i)

                    list.add(
                        mapOf(
                            "notificationId" to obj.getString("notificationId"),
                            "amount" to obj.getDouble("amount"),
                            "type" to obj.getString("type"),
                            "sourceApp" to obj.getString("sourceApp"),
                            "merchant" to obj.getString("merchant"),
                            "timestamp" to obj.getLong("timestamp")
                        )
                    )
                }

                result.success(list)
            }

            "clearPendingTransactions" -> {

                PendingTransactionQueue.clear(context)

                result.success(null)
            }

            else -> result.notImplemented()
        }
    }
}   