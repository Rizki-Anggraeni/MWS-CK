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
      title: 'Daily Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16A085)),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        cardTheme: const CardThemeData(
          elevation: 1,
          shadowColor: Colors.black12,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
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
