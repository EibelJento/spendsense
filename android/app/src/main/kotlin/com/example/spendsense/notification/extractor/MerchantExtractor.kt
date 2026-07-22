package com.example.spendsense.notification.extractor

import com.example.spendsense.notification.domain.RawNotification

object MerchantExtractor {

    fun extract(notification: RawNotification): String? {

        val content =
            "${notification.title.orEmpty()} ${notification.text.orEmpty()}"

        // Pattern: "ARJUN S NAIR paid you ₹3"
        Regex(
            """^(.+?)\s+paid you""",
            RegexOption.IGNORE_CASE,
        ).find(content)?.let {
            return it.groupValues[1].trim()
        }

        // Pattern: "Paid ₹250 to Swiggy"
        Regex(
            """paid\s+₹?[\d,.]+\s+to\s+(.+)""",
            RegexOption.IGNORE_CASE,
        ).find(content)?.let {
            return it.groupValues[1].trim()
        }

        return null
    }
}