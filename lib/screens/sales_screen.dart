import 'package:flutter/material.dart';
import '../data/global_data.dart'; // Import global data

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  int? selectedIndex;
  final TextEditingController qtyController = TextEditingController();

  void _registerSale() {
    if (selectedIndex == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Выберите товар")));
      return;
    }
    int qty = int.tryParse(qtyController.text) ?? 0;
    var product = products[selectedIndex!];

    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Количество должно быть больше нуля")),
      );
      return;
    }
    if (qty > (product['qty'] as int)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Недостаточно товара: доступно ${product['qty']}"),
        ),
      );
      return;
    }

    setState(() {
      product['qty'] = (product['qty'] as int) - qty;
      sales.add(<String, dynamic>{
        'product': product['name'],
        'qty': qty,
        'profit':
            ((product['sellPrice'] as double) -
                (product['buyPrice'] as double)) *
            qty,
        'date': DateTime.now(),
      });
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Продажа зарегистрирована")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Регистрация продажи")),
      body: products.isEmpty
          ? const Center(
              child: Text("Нет товаров для продажи. Добавьте товары."),
            )
          : SingleChildScrollView(
              // Added SingleChildScrollView to prevent overflow
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  DropdownButton<int>(
                    hint: const Text("Выберите товар"),
                    isExpanded: true,
                    value: selectedIndex,
                    items: List<DropdownMenuItem<int>>.generate(
                      // Specified generic type
                      products.length,
                      (int i) => DropdownMenuItem<int>(
                        value: i,
                        child: Text(
                          products[i]['name'].toString(),
                        ), // Ensure text is string
                      ),
                    ),
                    onChanged: (int? val) {
                      // Specified parameter type
                      setState(() {
                        selectedIndex = val;
                      });
                    },
                  ),
                  TextField(
                    controller: qtyController,
                    decoration: const InputDecoration(labelText: "Количество"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _registerSale,
                    child: const Text("Зарегистрировать"),
                  ),
                ],
              ),
            ),
    );
  }
}
