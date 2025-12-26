import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category; // Makan, Transportasi, Kost, Kuliah, Hiburan

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String note;

  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  factory Expense.fromJson(Map<String, dynamic> json, {String? id}) {
    final rawDate = json['date'];
    DateTime dt;
    if (rawDate is Timestamp) {
      dt = rawDate.toDate();
    } else if (rawDate is DateTime) {
      dt = rawDate;
    } else if (rawDate is String) {
      dt = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      dt = DateTime.now();
    }
    return Expense(
      id: id ?? json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: dt,
      note: (json['note'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'category': category,
    'date': Timestamp.fromDate(date),
    'note': note,
  };
}
