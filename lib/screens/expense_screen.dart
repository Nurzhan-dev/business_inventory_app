import 'package:flutter/material.dart';
import '../data/global_data.dart'; // Import global data

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  void _addExpense() {
    setState(() {
      expenses.add({
        'description': descriptionController.text,
        'amount': double.tryParse(amountController.text) ?? 0,
      });
      descriptionController.clear();
      amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Учёт расходов")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Описание"),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: "Сумма"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addExpense,
              child: Text("Добавить расход"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.money_off, color: Colors.red),
                    title: Text(expenses[index]['description']),
                    subtitle: Text(
                      "Сумма: ${expenses[index]['amount'].toStringAsFixed(2)} ₸",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
