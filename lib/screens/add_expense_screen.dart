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
  String _category = 'Makan';
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = const [
      'Makan',
      'Transportasi',
      'Kost',
      'Kuliah',
      'Hiburan',
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: const [
                    Icon(Icons.add_card, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Tambah Pengeluaran',
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
                                  labelText: 'Nominal',
                                  prefixText: 'Rp ',
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'),
                                  ),
                                ],
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Masukkan nominal';
                                  }
                                  final parsed = double.tryParse(v);
                                  if (parsed == null || parsed <= 0) {
                                    return 'Nominal tidak valid';
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
                                      selectedColor: const Color(
                                        0xFF16A085,
                                      ).withValues(alpha: 0.15),
                                      labelStyle: TextStyle(
                                        color: _category == c
                                            ? const Color(0xFF16A085)
                                            : const Color(0xFF2B3C4E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: _category == c
                                              ? const Color(0xFF16A085)
                                              : const Color(0xFFE0E6ED),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'Tanggal',
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
                              TextFormField(
                                controller: _noteCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Catatan (opsional)',
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: _save,
                                  icon: const Icon(Icons.save),
                                  label: const Text('Simpan'),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
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
    final e = Expense(
      id: id,
      amount: amount,
      category: _category,
      date: _date,
      note: _noteCtrl.text.trim(),
    );
    expenseRepo.add(e);
    Navigator.of(context).pop();
  }

  static String _dateString(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }
}
