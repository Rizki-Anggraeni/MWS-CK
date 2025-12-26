import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/locator.dart';
import 'add_expense_screen.dart';

const expenseBoxName = 'expense_box';

final Map<String, (IconData, Color)> kCategoryIconMap = {
  'Makan': (Icons.restaurant, Colors.green),
  'Transportasi': (Icons.directions_bus, Colors.blue),
  'Kost': (Icons.home, Colors.orange),
  'Kuliah': (Icons.school, Colors.purple),
  'Hiburan': (Icons.movie, Colors.pink),
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currencyCode = 'IDR';

  static const Map<String, ({String symbol, String locale, double rate})>
  _currencies = {
    'IDR': (symbol: 'Rp', locale: 'id_ID', rate: 1.0),
    'USD': (symbol: '\$', locale: 'en_US', rate: 0.000065),
    'EUR': (symbol: '€', locale: 'en_US', rate: 0.000061),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Expense>>(
        stream: expenseRepo.watchAll(),
        builder: (context, snap) {
          final items = (snap.data ?? [])
            ..sort((a, b) => b.date.compareTo(a.date));
          final now = DateTime.now();
          final totalIdr = items
              .where(
                (e) => e.date.month == now.month && e.date.year == now.year,
              )
              .fold<double>(0, (p, e) => p + e.amount);
          final rate = _currencies[_currencyCode]!.rate;
          final totalConverted = totalIdr * rate;
          final grouped = _groupByDate(items);
          final datesDesc = grouped.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF16A085), Color(0xFF2ECC71)],
                stops: [0.0, 0.7],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Halo, mari catat pengeluaran',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Daily Expense Tracker',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: const Color(0xFF12856F),
                              iconEnabledColor: Colors.white,
                              value: _currencyCode,
                              items: _currencies.keys
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        c,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() => _currencyCode = v);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _SummaryCard(
                      total: totalConverted,
                      currencyCode: _currencyCode,
                      count: items.length,
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: items.isEmpty
                            ? const _EmptyState()
                            : ListView(
                                children: [
                                  for (final day in datesDesc) ...[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        8,
                                        12,
                                        8,
                                        6,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _sectionHeader(day),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF2B3C4E),
                                            ),
                                          ),
                                          Text(
                                            '${grouped[day]!.length} transaksi',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF708090),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    for (final e in grouped[day]!)
                                      _ExpenseItem(
                                        e: e,
                                        currencyCode: _currencyCode,
                                        onDelete: () =>
                                            expenseRepo.delete(e.id),
                                      ),
                                  ],
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }

  Map<DateTime, List<Expense>> _groupByDate(List<Expense> items) {
    final map = <DateTime, List<Expense>>{};
    for (final e in items) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      map.putIfAbsent(day, () => []);
      map[day]!.add(e);
    }
    return map;
  }

  static String _sectionHeader(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }
}

class _ExpenseItem extends StatelessWidget {
  final Expense e;
  final String currencyCode;
  final VoidCallback onDelete;

  const _ExpenseItem({
    required this.e,
    required this.currencyCode,
    required this.onDelete,
  });

  static const Map<String, ({String symbol, String locale, double rate})>
  _currencies = _HomeScreenState._currencies;

  @override
  Widget build(BuildContext context) {
    final (iconData, color) =
        kCategoryIconMap[e.category] ?? (Icons.category, Colors.grey);
    final rate = _currencies[currencyCode]!.rate;
    final converted = e.amount * rate;
    final formatter = NumberFormat.currency(
      locale: _currencies[currencyCode]!.locale,
      symbol: _currencies[currencyCode]!.symbol,
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          leading: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(iconData, color: color, size: 24),
          ),
          title: Text(
            e.category,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                formatter.format(converted),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2B3C4E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                e.note.isEmpty
                    ? _dateString(e.date)
                    : '${_dateString(e.date)}  ·  ${e.note}',
                style: const TextStyle(color: Color(0xFF708090)),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onDelete,
            tooltip: 'Hapus',
          ),
        ),
      ),
    );
  }

  static String _dateString(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }
}

class _SummaryCard extends StatelessWidget {
  final double total;
  final String currencyCode;
  final int count;

  const _SummaryCard({
    required this.total,
    required this.currencyCode,
    required this.count,
  });

  static const Map<String, ({String symbol, String locale, double rate})>
  _currencies = _HomeScreenState._currencies;

  @override
  Widget build(BuildContext context) {
    final cur = _currencies[currencyCode]!;
    final formatter = NumberFormat.currency(
      locale: cur.locale,
      symbol: cur.symbol,
      decimalDigits: 0,
    );
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total bulan ini',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatter.format(total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Badge(
                        label: currencyCode,
                        icon: Icons.currency_exchange,
                      ),
                      const SizedBox(width: 8),
                      _Badge(label: '$count transaksi', icon: Icons.list_alt),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.show_chart, color: Colors.white70, size: 32),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Badge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.inbox_rounded, size: 56, color: Color(0xFFB0BEC5)),
            SizedBox(height: 12),
            Text(
              'Belum ada pengeluaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF455A64),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Tekan tombol Tambah untuk mulai mencatat.',
              style: TextStyle(color: Color(0xFF78909C)),
            ),
          ],
        ),
      ),
    );
  }
}
