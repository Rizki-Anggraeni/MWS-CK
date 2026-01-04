# Manajer Langganan (Hive)

Sebuah aplikasi Flutter sederhana untuk mengelola langganan bulanan dengan penyimpanan lokal menggunakan Hive.

## Fitur
- UI Material 3
- Tambah, lihat, dan hapus langganan
- Periode langganan (Sekali / Mingguan / Bulanan / Tahunan) dan otomatisasi tanggal tagihan berikutnya
- Total biaya bulanan
- Kategori, pemilih tanggal, dan input angka untuk biaya

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
