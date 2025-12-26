# Daily Expense Tracker (Hive)

A simple Flutter app to track daily expenses with local storage using Hive.

## Features
- Material 3 UI
- Add, list, and delete expenses
- Total spending for the current month
- Category dropdown, date picker, and numeric amount filter

## Setup
1. Install dependencies and generate adapters:

```powershell
cd "d:\Agung Kuliah\Semester 5\MWS\flutter\catatan_keuangan"
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

2. Run the app on a connected device/emulator:

```powershell
flutter run
```

> Hive is initialized in `lib/main.dart`, using a box named `expense_box` with a generated `ExpenseAdapter`.
