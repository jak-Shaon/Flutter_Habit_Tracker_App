# 📱 Habit Tracker

A modern and intuitive Habit Tracking mobile application built with **Flutter** and **Firebase**, designed to help users create, track, and manage daily habits, stay motivated with inspirational quotes, and view progress with interactive charts.  
The app also supports **Dark/Light themes**, **real-time updates**, and comes with its own **custom app icon**.

---

## 🚀 Features

### 🔐 Authentication
- User Registration & Login with Firebase Authentication (Email & Password).
- Secure logout functionality.

### ✅ Habit Management
- Create, update, and delete daily habits.
- Add **notes field** in habits to allow extra details.
- Track progress in an intuitive list view.
- **Daily/Weekly Progress Chart** – updates dynamically as completion status changes.
- Pull-to-refresh support for habit list updates.
- Filter habits (planned, completed, etc.).

### 💡 Motivational Quotes
- Display daily motivational quotes in a scrollable list/carousel.
- **Copy quotes** functionality.
- Mark quotes as **Favourite/Unfavourite**.
- Fetch quotes from a free public quotes API (Quotable, ZenQuotes, etc.).
- If API fetch fails → fallback to locally saved quotes.

### ❤ Favourites
- Favourite Quotes are added to this page.
- Can Unfavourite quotes directly from the favourites screen.

### 👤 Profile Management
- View and manage user profile.
- Profile updates in **real-time**.
- Logout option directly from the top-right corner.

### ⚙️ Settings
- Toggle **Dark/Light theme** instantly.
- Manage basic app preferences.
- Preferences are stored locally and synced with Firestore.

### 🎨 Theme Information
- Support for **Light Mode** and **Dark Mode**.
- Immediate theme application (no restart needed).
- Synced across sessions with Firebase.

---

## 📂 Project Structure

```
lib/
 ├── main.dart
 ├── firebase_option.dart
 ├── services/
 │    ├── auth_service.dart
 │    ├── firestore_service.dart
 │    ├── quotes_service.dart
 │
 ├── providers/
 │    ├── auth_provider.dart
 │    ├── habit_provider.dart
 │    ├── theme_provider.dart
 │
 ├── models/
 │    ├── user_model.dart
 │    ├── habit_model.dart
 │    ├── quote_model.dart
 │
 ├── screens/
 │    ├── auth/
 │    │    ├── login_screen.dart
 │    │    ├── register_screen.dart
 │    │
 │    ├── profile_screen.dart
 │    ├── home_screen.dart
 │    ├── habit/
 │    │    ├── favorite_screen.dart 
 │    │    ├── home_screen.dart 
 │    │    ├── profile_screen.dart
 │    │    ├── quotes_screen.dart 
 │    │    ├── settings_screen.dart 
 │
 ├── widgets/
 │    ├── custom_button.dart
 │    ├── habit_card.dart
 │    ├── quote_card.dart
 │    ├── progress_chart.dart
```

---

## 📸 Preview

> ![Light Mode](https://github.com/user-attachments/assets/4614b93f-5107-463d-aa24-c404b2b61293) <br>
 ![Dark Mode](https://github.com/user-attachments/assets/fd7460fb-f954-452e-ab75-e35eb0c5b927)




---

## 🛠️ Tech Stack
- **Flutter** (Dart)
- **Firebase Authentication**
- **Firebase Firestore**
- **Firebase Core**
- **Provider (State Management)**
- **REST API** (for Quotes)

---

## 📦 Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/jak-Shaon/Flutter_Habit_Tracker_App]
   cd habit_tracker_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
   - Ensure Firebase Authentication & Firestore are enabled in the Firebase Console.

4. Run the app:
   ```bash
   flutter run
   ```

---

## 📌 Notes
- The app includes a **custom app icon**.
- All data is securely synced with Firebase.

---

## 🤝 Contributing
Contributions are welcome! Feel free to fork the repo and submit a pull request.

---

## 📄 License
This project is licensed under the **MIT License**.

---

### 👨‍💻 Author
Developed by **Jahidul Alam Khan Shaon**  
📧 Contact: [jahidshaon28@gmail.com]  
🔗 GitHub: [jak-Shaon](https://github.com/jak-Shaon)
