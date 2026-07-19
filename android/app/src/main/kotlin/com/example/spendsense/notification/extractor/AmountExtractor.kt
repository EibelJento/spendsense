package com.example.spendsense.notification.extractor

import com.example.spendsense.notification.domain.RawNotification

object AmountExtractor {

    private val amountRegex =
        Regex("""(?:₹|Rs\.?|INR)\s?([\d,]+(?:\.\d{1,2})?)""")

    fun extract(notification: RawNotification): Double? {

        val content = "${notification.title} ${notification.text}"

        val match = amountRegex.find(content)

        if (match != null) {
            return match.groupValues[1]
                .replace(",", "")
                .toDoubleOrNull()
        }

        return null
    }
}
