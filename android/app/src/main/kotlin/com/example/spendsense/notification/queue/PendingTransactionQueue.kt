package com.example.spendsense.notification.queue

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import android.util.Log

object PendingTransactionQueue {

    private const val PREF_NAME = "spendsense_queue"
    private const val KEY_QUEUE = "pending_transactions"

    fun enqueue(context: Context, transaction: JSONObject) {

        val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)

        val queue = JSONArray(
            prefs.getString(KEY_QUEUE, "[]")
        )

        queue.put(transaction)

        prefs.edit()
            .putString(KEY_QUEUE, queue.toString())
            .apply()
        Log.d("PendingQueue", queue.toString())
    }

    fun getAll(context: Context): JSONArray {

        val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)

        return JSONArray(
            prefs.getString(KEY_QUEUE, "[]")
        )
    }

    fun clear(context: Context) {

        context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        ).edit()
            .remove(KEY_QUEUE)
            .apply()
    }
}