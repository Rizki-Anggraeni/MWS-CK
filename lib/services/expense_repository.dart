import 'package:cloud_firestore/cloud_firestore.dart';
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
  final CollectionReference<Expense> _col = FirebaseFirestore.instance
      .collection('expenses')
      .withConverter<Expense>(
        fromFirestore: (snap, _) =>
            Expense.fromJson(snap.data() ?? {}, id: snap.id),
        toFirestore: (Expense e, _) => e.toJson(),
      );

  @override
  Future<void> add(Expense e) async {
    await _col.doc(e.id).set(e);
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  @override
  Stream<List<Expense>> watchAll() {
    return _col.orderBy('date', descending: true).snapshots().map(
          (s) => s.docs.map((d) => d.data()).toList(),
        );
  }
}
