import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/expense.dart';
import '../services/locator.dart';
// import 'home_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _category = 'Streaming';
  DateTime _date = DateTime.now();
  DateTime? _nextBillingDate;
  String _frequency = 'Bulanan';
  String _paymentType = 'Langganan';

  DateTime _computeNextBilling(DateTime from, String frequency) {
    switch (frequency) {
      case 'Mingguan':
        return from.add(const Duration(days: 7));
      case 'Tahunan':
        return DateTime(from.year + 1, from.month, from.day);
      case 'Bulanan':
      default:
        final nextMonth = DateTime(from.year, from.month + 1, from.day);
        // If day overflow (e.g., Jan 31 -> Feb 31 invalid), fallback to last day of next month
        if (nextMonth.month == ((from.month % 12) + 1)) return nextMonth;
        final lastDay = DateTime(from.year, from.month + 2, 0).day;
        return DateTime(from.year, from.month + 1, lastDay);
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = const [
      'Game',
      'Streaming',
      'Kesehatan',
      'Utilitas',
      'Lainnya',
    ];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF16A085), Color(0xFF2ECC71)],
            stops: [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Tambah Langganan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _amountCtrl,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.attach_money_rounded),
                                  labelText: 'Biaya per periode',
                                  prefixText: 'Rp ',
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                ],
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Masukkan biaya';
                                  }
                                  final parsed = double.tryParse(v);
                                  if (parsed == null || parsed <= 0) {
                                    return 'Biaya tidak valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Kategori',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2B3C4E),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final c in categories)
                                    ChoiceChip(
                                      label: Text(c),
                                      selected: _category == c,
                                      onSelected: (_) => setState(() {
                                        _category = c;
                                      }),
                                      selectedColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
                                      labelStyle: TextStyle(
                                        color: _category == c ? Theme.of(context).colorScheme.primary : const Color(0xFF2B3C4E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: _category == c ? Theme.of(context).colorScheme.primary : const Color(0xFFE0E6ED),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Periode',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2B3C4E),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final f in [
                                    'Sekali',
                                    'Mingguan',
                                    'Bulanan',
                                    'Tahunan',
                                  ])
                                    ChoiceChip(
                                      label: Text(f),
                                      selected: _frequency == f,
                                      onSelected: (_) => setState(() {
                                        _frequency = f;
                                      }),
                                      selectedColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
                                      labelStyle: TextStyle(
                                        color: _frequency == f ? Theme.of(context).colorScheme.primary : const Color(0xFF2B3C4E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: _frequency == f ? Theme.of(context).colorScheme.primary : const Color(0xFFE0E6ED),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'Tanggal Tagihan',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                subtitle: Text(_dateString(_date)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.date_range),
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _date,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      setState(() => _date = picked);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'Tanggal Tagihan Berikutnya',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                subtitle: Text(
                                  _nextBillingDate == null
                                      ? 'Belum diatur'
                                      : _dateString(_nextBillingDate!),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.date_range),
                                      onPressed: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              _nextBillingDate ?? _date,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                        if (picked != null) {
                                          setState(
                                            () => _nextBillingDate = picked,
                                          );
                                        }
                                      },
                                    ),
                                    if (_nextBillingDate != null)
                                      IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () => setState(
                                          () => _nextBillingDate = null,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tipe Pembayaran',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2B3C4E),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final p in [
                                    'Langganan',
                                    'Kredit',
                                    'PayLater',
                                  ])
                                    ChoiceChip(
                                      label: Text(p),
                                      selected: _paymentType == p,
                                      onSelected: (_) => setState(() {
                                        _paymentType = p;
                                      }),
                                      selectedColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
                                      labelStyle: TextStyle(
                                        color: _paymentType == p ? Theme.of(context).colorScheme.primary : const Color(0xFF2B3C4E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: _paymentType == p ? Theme.of(context).colorScheme.primary : const Color(0xFFE0E6ED),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _noteCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Deskripsi (opsional)',
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _save,
                                  icon: const Icon(Icons.save, color: Colors.white),
                                  label: const Text('Simpan Langganan', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF16A085),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountCtrl.text);
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    // If this is a recurring subscription and user didn't pick a next billing date,
    // compute one automatically from the selected date.
    if (_frequency != 'Sekali' && _nextBillingDate == null) {
      _nextBillingDate = _computeNextBilling(_date, _frequency);
    }

    final e = Expense(
      id: id,
      amount: amount,
      category: _category,
      date: _date,
      note: _noteCtrl.text.trim(),
      nextBillingDate: _nextBillingDate,
      frequency: _frequency,
      paymentType: _paymentType,
    );
    expenseRepo.add(e);
    Navigator.of(context).pop();
  }

  static String _dateString(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }
}
