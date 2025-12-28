import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> watchAll();
  Future<void> add(Expense e);
  Future<void> delete(String id);
}

class HiveExpenseRepository implements ExpenseRepository {
  final Box<Expense> box;
  HiveExpenseRepository(this.box);

  @override
  Future<void> add(Expense e) async {
    await box.put(e.id, e);
  }

  @override
  Future<void> delete(String id) async {
    await box.delete(id);
  }

  @override
  Stream<List<Expense>> watchAll() {
    return box.watch().map((_) => box.values.toList());
  }
}

class FirestoreExpenseRepository implements ExpenseRepository {
  CollectionReference<Expense> _collectionForUser() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final base = FirebaseFirestore.instance;
    final col = uid != null
        ? base.collection('users').doc(uid).collection('expenses')
        : base.collection('expenses');
    return col.withConverter<Expense>(
      fromFirestore: (snap, _) =>
          Expense.fromJson(snap.data() ?? {}, id: snap.id),
      toFirestore: (Expense e, _) => e.toJson(),
    );
  }

  @override
  Future<void> add(Expense e) async {
    await _collectionForUser().doc(e.id).set(e);
  }

  @override
  Future<void> delete(String id) async {
    await _collectionForUser().doc(id).delete();
  }

  @override
  Stream<List<Expense>> watchAll() {
    return _collectionForUser()
        .orderBy('date', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }
}
