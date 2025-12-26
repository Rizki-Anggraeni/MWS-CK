import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';
import 'expense_repository.dart';

late ExpenseRepository expenseRepo;

void setupRepositories(Box<Expense> box) {
  if (Firebase.apps.isNotEmpty) {
    expenseRepo = FirestoreExpenseRepository();
    if (kDebugMode) {
      print('✅ Firebase initialized - Using Firestore backend');
    }
  } else {
    expenseRepo = HiveExpenseRepository(box);
    if (kDebugMode) {
      print('⚠️ Firebase not initialized - Using Hive backend');
    }
  }
}
