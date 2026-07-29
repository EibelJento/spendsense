# 💰 SpendSense

> A smart expense tracking application built with Flutter that automatically detects transactions from SMS and notifications, helping users manage their finances with minimal manual effort.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Kotlin](https://img.shields.io/badge/Kotlin-Android-orange?logo=kotlin)
![SQLite](https://img.shields.io/badge/SQLite-Local%20Database-green)
![Platform](https://img.shields.io/badge/Platform-Android-success)

---

# 📖 About

SpendSense is a Flutter-based personal finance application that combines Flutter and native Android components to automate expense tracking.

The application detects expense transactions from SMS and income transactions from notifications, stores them locally using SQLite, and enriches expense transactions with GPS location data that can be viewed directly in Google Maps.

The project follows production-style development practices with a scalable architecture and clean separation between Flutter and Android native modules.

---

# ✨ Features

### Transaction Management

- ✅ Add, edit and delete transactions
- ✅ Income & expense tracking
- ✅ Automatic balance calculation
- ✅ Category management
- ✅ Transaction notes
- ✅ Local SQLite storage
- ✅ Transaction detail screen

### Smart Detection

- ✅ Automatic expense detection from SMS
- ✅ Automatic income detection from notifications
- ✅ Merchant recognition
- ✅ Automatic transaction creation

### Location Features

- ✅ Continuous foreground location tracking
- ✅ GPS tagging for expense transactions
- ✅ Reverse geocoding (address lookup)
- ✅ View transaction location in Google Maps

### User Experience

- ✅ Material 3 UI
- ✅ Android 14/15 compatible
- ✅ Offline-first architecture
- ✅ Fast local database

---

# 🏗️ Architecture

```
SMS
   │
   ▼
SmsReceiver
   │
   ▼
Payment Detector
   │
   ▼
Current Location Cache
   │
   ▼
SQLite
   │
   ▼
Flutter UI
```

```
Notifications
      │
      ▼
Notification Listener
      │
      ▼
Payment Detector
      │
      ▼
SQLite
      │
      ▼
Flutter UI
```

---

# 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | Cross-platform UI |
| Dart | Application logic |
| Kotlin | Native Android integration |
| SQLite | Local database |
| sqflite | Database plugin |
| MethodChannel | Flutter ↔ Android communication |
| NotificationListenerService | Income detection |
| BroadcastReceiver | SMS detection |
| Foreground Service | Continuous location tracking |
| Geolocator | GPS location |
| Geocoding | Address lookup |
| url_launcher | Google Maps integration |
| SharedPreferences | Local settings |

---

# 📂 Project Structure

```
lib/
│
├── data/
│   ├── database/
│   └── models/
│
├── screens/
│
├── services/
│   ├── location/
│   ├── notification/
│   └── database/
│
├── widgets/
│
└── main.dart

android/
└── Native Kotlin implementation
```

---

# 🚀 Getting Started

Clone the repository

```bash
git clone https://github.com/yourusername/spendsense.git
```

Move into the project

```bash
cd spendsense
```

Install dependencies

```bash
flutter pub get
```

Run the application

```bash
flutter run
```

---

# 📌 Roadmap

### Completed

- [x] SQLite integration
- [x] Repository pattern
- [x] Add/Edit/Delete transactions
- [x] SMS transaction detection
- [x] Notification transaction detection
- [x] Continuous GPS tracking
- [x] Reverse geocoding
- [x] Google Maps integration
- [x] Transaction details
- [x] Android 14/15 compatibility

### Planned

- [ ] Search transactions
- [ ] Expense analytics
- [ ] Budget tracking
- [ ] Charts & reports
- [ ] CSV/PDF export
- [ ] Cloud backup & sync
- [ ] OCR receipt scanner
- [ ] AI-powered expense insights

---

# 🎯 Development Highlights

- Clean Architecture
- Repository Pattern
- Feature-based organization
- Flutter & Kotlin integration
- Native Android Services
- Offline-first design
- Scalable and maintainable codebase

---

# 📄 License

This project is licensed under the MIT License.

---

## ⭐ If you found this project useful, consider giving it a star!
