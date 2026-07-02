# Todo App

A Flutter Todo application powered by Firebase Firestore.

## Features

- Create new tasks
- View all tasks
- Update existing tasks
- Delete tasks
- Real-time synchronization using Cloud Firestore

---

## Prerequisites

Before running this project, make sure you have installed:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Firebase CLI
- FlutterFire CLI

Install the FlutterFire CLI if you don't already have it:

```bash
dart pub global activate flutterfire_cli
```

---

## Project Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd todo_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Create a Firebase project

Go to the Firebase Console:

https://console.firebase.google.com/

Create a new Firebase project (or use an existing one).

---

### 4. Enable Cloud Firestore

Inside your Firebase project:

- Go to **Build → Firestore Database**
- Create a Firestore database
- Choose either Production or Test mode

---

### 5. Register your app

Register the required platforms in Firebase.

For Android:

- Add an Android app
- Use your package name from:

```
android/app/src/main/AndroidManifest.xml
```

For iOS (optional):

- Add an iOS app
- Use the Bundle Identifier from Xcode

---

### 6. Configure FlutterFire

Run:

```bash
flutterfire configure
```

Select:

- Your Firebase project
- The platforms you want to support

FlutterFire will automatically generate:

```
lib/firebase_options.dart
```

This file is intentionally excluded from version control and must be generated locally.

---

## Running the application

```bash
flutter run
```

---

## Project Structure

```
lib/
│
├── main.dart
├── firebase_options.dart   (Generated locally)
├── screens/
├── widgets/
└── ...
```

---

## Why isn't `firebase_options.dart` included?

The project ignores `lib/firebase_options.dart` because each developer should connect the application to their own Firebase project.

Generate it by running:

```bash
flutterfire configure
```

before running the application.

---

## Useful Commands

Install dependencies:

```bash
flutter pub get
```

Generate Firebase configuration:

```bash
flutterfire configure
```

Run the application:

```bash
flutter run
```

Run tests:

```bash
flutter test
```

---

## Resources

- https://docs.flutter.dev/
- https://firebase.google.com/docs/flutter/setup
- https://firebase.flutter.dev/