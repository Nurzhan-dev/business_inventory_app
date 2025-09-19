import 'package:flutter/material.dart';
import '../data/global_data.dart'; // Import global data

class ReportsScreen extends StatelessWidget {
  double get totalProfit =>
      sales.fold(0, (sum, s) => sum + (s['profit'] as double));

  double get totalExpenses =>
      expenses.fold(0, (sum, e) => sum + (e['amount'] as double));

  Map<String, int> get topProducts {
    Map<String, int> counts = {};
    for (var s in sales) {
      counts[s['product']] = (counts[s['product']] ?? 0) + (s['qty'] as int);
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    double netProfit = totalProfit - totalExpenses;

    return Scaffold(
      appBar: AppBar(title: Text("Отчёты")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Карточка общей прибыли ---
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: Icon(Icons.trending_up, color: Colors.green),
                title: Text("Общая прибыль"),
                subtitle: Text("$totalProfit ₸"),
              ),
            ),
            // --- Карточка расходов ---
            Card(
              color: Colors.red.shade50,
              child: ListTile(
                leading: Icon(Icons.money_off, color: Colors.red),
                title: Text("Общие расходы"),
                subtitle: Text("$totalExpenses ₸"),
              ),
            ),
            // --- Карточка чистой прибыли ---
            Card(
              color: netProfit >= 0 ? Colors.blue.shade50 : Colors.red.shade100,
              child: ListTile(
                leading: Icon(
                  Icons.account_balance_wallet,
                  color: netProfit >= 0 ? Colors.blue : Colors.red,
                ),
                title: Text("Чистая прибыль"),
                subtitle: Text("$netProfit ₸"),
              ),
            ),
            SizedBox(height: 16),

            // --- Кол-во продаж ---
            Card(
              child: ListTile(
                leading: Icon(Icons.shopping_cart, color: Colors.orange),
                title: Text("Количество продаж"),
                subtitle: Text("${sales.length} операций"),
              ),
            ),
            SizedBox(height: 16),

            // --- Самые продаваемые товары ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Топ продаваемых товаров:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...topProducts.entries.map((e) {
              double percent =
                  e.value / (topProducts.values.fold(0, (a, b) => a + b));
              return Column(
                children: [
                  ListTile(
                    title: Text(e.key),
                    trailing: Text("${e.value} шт."),
                  ),
                  LinearProgressIndicator(
                    value: percent,
                    color: Colors.blue,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  SizedBox(height: 8),
                ],
              );
            }),

            SizedBox(height: 20),
            // --- Последние расходы ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Последние расходы:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...expenses.reversed
                .take(3)
                .map(
                  (e) => ListTile(
                    leading: Icon(Icons.remove_circle, color: Colors.red),
                    title: Text(e['description']),
                    trailing: Text("${e['amount']} ₸"),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
