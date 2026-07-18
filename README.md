# 💰 SpendSense

> An intelligent expense tracking application built with Flutter, designed to help users remember, organize, and analyze their spending effortlessly.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![SQLite](https://img.shields.io/badge/SQLite-Local%20Database-green)
![Platform](https://img.shields.io/badge/Platform-Android-success)

---

## 📖 About

SpendSense is a modern personal finance application built using **Flutter** and **SQLite**.

Unlike traditional expense trackers that require manual bookkeeping, SpendSense aims to evolve into an intelligent financial companion capable of automatically detecting payments, attaching contextual information, and providing AI-powered financial insights.

This project is being developed as a production-style application with scalability, clean architecture, and maintainability in mind.

---

# ✨ Current Features

- ✅ Add income and expense transactions
- ✅ Store transactions locally using SQLite
- ✅ View transaction history
- ✅ Automatic balance calculation
- ✅ Category support
- ✅ Notes for transactions
- ✅ Material 3 UI
- ✅ Repository Pattern
- ✅ Feature-based architecture

---

# 🚀 Planned Features

### Transaction Management

- Edit transactions
- Delete transactions
- Search transactions
- Advanced filters
- Transaction details page

### Analytics

- Monthly spending reports
- Category-wise analysis
- Income vs Expense charts
- Spending trends
- Budget tracking

### Smart Features

- UPI payment detection
- Notification Listener
- Automatic transaction suggestions
- Merchant recognition
- Receipt scanner (OCR)
- Voice notes
- Location tagging

### AI Features

- Natural language search

Examples:

- "Show my Swiggy expenses"
- "How much did I spend on food last month?"
- "Show payments made yesterday"

### Productivity

- CSV Export
- PDF Reports
- Cloud Backup
- Dark Mode
- Multi-currency Support

---

# 🏗️ Project Structure

```
lib/
│
├── app.dart
├── main.dart
│
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   ├── extensions/
│   └── errors/
│
├── data/
│   ├── database/
│   └── models/
│
├── features/
│   ├── home/
│   ├── transactions/
│   ├── analytics/
│   ├── search/
│   └── settings/
│
├── services/
│   ├── notification/
│   ├── location/
│   ├── ocr/
│   └── export/
│
└── shared/
    ├── widgets/
    ├── dialogs/
    └── animations/
```

---

# 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | Cross-platform UI |
| Dart | Programming Language |
| SQLite | Local Storage |
| sqflite | SQLite Plugin |
| Material 3 | UI Design |
| Repository Pattern | Data Layer |
| Feature-first Architecture | Scalability |

---

# 🎯 Development Philosophy

SpendSense is built following production-level software engineering practices.

- Feature-first architecture
- Repository pattern
- Modular codebase
- Strong typing
- Reusable widgets
- Clean separation of concerns
- Scalable folder structure
- Maintainable code

The goal is to build a project that resembles a real-world mobile application rather than a tutorial-based demo.

---

# 📱 Screens

- Home Dashboard
- Add Transaction
- Transaction History

*(More screens will be added as development progresses.)*

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

- [x] Project Setup
- [x] SQLite Integration
- [x] Transaction Repository
- [x] Add Transactions
- [x] Load Transactions
- [ ] Edit Transactions
- [ ] Delete Transactions
- [ ] Search
- [ ] Analytics Dashboard
- [ ] Charts
- [ ] Budget Tracking
- [ ] Notification Listener
- [ ] OCR Receipts
- [ ] Location Tracking
- [ ] AI Search
- [ ] Cloud Backup
- [ ] Export Reports

---

# 🤝 Contributing

Contributions, suggestions, and feedback are always welcome.

If you'd like to improve SpendSense:

1. Fork the repository
2. Create a new branch
3. Commit your changes
4. Open a Pull Request

---

# 📄 License

This project is licensed under the MIT License.

---

## ⭐ If you like this project, consider giving it a star!

It motivates further development and helps others discover the project.
