import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth_screen.dart';
import 'models/expense.dart';
import 'screens/home_screen.dart';
import 'services/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _init().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajer Langganan',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF0F9D58),
          onPrimary: Colors.white,
          secondary: Color(0xFF16A085),
          onSecondary: Colors.white,
          error: Colors.redAccent,
          onError: Colors.white,
          surface: Color(0xFFF4F7FB),
          onSurface: Color(0xFF263238),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black12,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: const Color(0xFF16A085),
          ),
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: Color(0xFFF1F8F4),
          disabledColor: Colors.grey,
          selectedColor: Color(0xFF16A085),
          secondarySelectedColor: Color(0xFF16A085),
          labelStyle: TextStyle(color: Color(0xFF2B3C4E), fontWeight: FontWeight.w600),
          secondaryLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        useMaterial3: true,
      ),
      home: _homeByAuth(),
    );
  }
}

Future<void> _init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  final box = await Hive.openBox<Expense>('expense_box');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Firebase not configured yet; keep using Hive.
  }

  setupRepositories(box);
}

Widget _homeByAuth() {
  if (Firebase.apps.isEmpty) {
    return const HomeScreen();
  }
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snap) {
      final user = snap.data;
      if (user == null) {
        return const AuthScreen();
      }
      return const HomeScreen();
    },
  );
}
