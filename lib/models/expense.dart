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

  @HiveField(5)
  final DateTime? nextBillingDate;

  @HiveField(6)
  final String frequency; // 'Sekali', 'Mingguan', 'Bulanan', 'Tahunan'

  @HiveField(7)
  final String paymentType; // 'Langganan', 'Kredit', 'PayLater'

  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
    this.nextBillingDate,
    required this.frequency,
    required this.paymentType,
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

    DateTime? next;
    final rawNext = json['nextBillingDate'];
    if (rawNext is Timestamp) {
      next = rawNext.toDate();
    } else if (rawNext is DateTime) {
      next = rawNext;
    } else if (rawNext is String) {
      next = DateTime.tryParse(rawNext);
    }

    return Expense(
      id: id ?? json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: dt,
      note: (json['note'] as String?) ?? '',
      nextBillingDate: next,
      frequency: (json['frequency'] as String?) ?? 'Bulanan',
      paymentType: (json['paymentType'] as String?) ?? 'Langganan',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'category': category,
    'date': Timestamp.fromDate(date),
    'note': note,
    'nextBillingDate': nextBillingDate == null
        ? null
        : Timestamp.fromDate(nextBillingDate!),
    'frequency': frequency,
    'paymentType': paymentType,
  };
}
