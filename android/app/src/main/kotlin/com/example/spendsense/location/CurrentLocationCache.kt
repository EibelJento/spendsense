package com.example.spendsense.location

object CurrentLocationCache {

    @Volatile
    var latitude: Double? = null

    @Volatile
    var longitude: Double? = null

    @Volatile
    var accuracy: Float? = null

    @Volatile
    var timestamp: Long = 0L

    fun update(
        latitude: Double,
        longitude: Double,
        accuracy: Float
    ) {
        this.latitude = latitude
        this.longitude = longitude
        this.accuracy = accuracy
        this.timestamp = System.currentTimeMillis()
    }

    fun clear() {
        latitude = null
        longitude = null
        accuracy = null
        timestamp = 0L
    }
}