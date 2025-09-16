import 'package:flutter/material.dart';

void main() {
  runApp(BusinessApp());
}

class BusinessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Учёт бизнеса',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

// Главный экран
class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Список товаров", "icon": Icons.list},
    {"title": "Добавить товар", "icon": Icons.add_box},
    {"title": "Зарегистрировать продажу", "icon": Icons.shopping_cart},
    {"title": "Отчёты", "icon": Icons.bar_chart},
    {"title": "Расходы", "icon": Icons.money_off},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Учёт бизнеса")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: menuItems.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            var item = menuItems[index];
            return ElevatedButton.icon(
              icon: Icon(item["icon"], size: 22),
              label: Text(
                item["title"],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue.shade200),
                ),
                elevation: 2,
              ),
              onPressed: () {
                if (index == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ProductListScreen()));
                } else if (index == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ProductDetailScreen()));
                } else if (index == 2) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SalesScreen()));
                } else if (index == 3) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => ReportsScreen()));
                } else if (index == 4) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => ExpenseScreen()));
                }
              },
            );
          },
        ),
      ),
    );
  }
}

// Глобальные списки (замена БД для теста)
List<Map<String, dynamic>> products = [];
List<Map<String, dynamic>> sales = [];

// Экран списка товаров
class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Список товаров")),
      body: products.isEmpty
          ? const Center(child: Text("Нет товаров. Добавьте новые товары."))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                var product = products[index];
                return ListTile(
                  title: Text(product['name'] as String),
                  subtitle: Text(
                      "Цена: ${product['sellPrice']}₸ | Кол-во: ${product['qty']}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<ProductDetailScreen>(
                        builder: (_) => ProductDetailScreen(editIndex: index),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

// Экран добавления/редактирования товара
class ProductDetailScreen extends StatefulWidget {
  final int? editIndex;
  const ProductDetailScreen({super.key, this.editIndex});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController buyPriceController = TextEditingController();
  final TextEditingController sellPriceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editIndex != null) {
      var product = products[widget.editIndex!];
      nameController.text = product['name'].toString();
      buyPriceController.text = product['buyPrice'].toString();
      sellPriceController.text = product['sellPrice'].toString();
      qtyController.text = product['qty'].toString();
      descController.text = product['desc'].toString();
    }
  }

  void _saveProduct() {
    var product = <String, dynamic>{
      'name': nameController.text,
      'buyPrice': double.tryParse(buyPriceController.text) ?? 0.0,
      'sellPrice': double.tryParse(sellPriceController.text) ?? 0.0,
      'qty': int.tryParse(qtyController.text) ?? 0,
      'desc': descController.text,
    };

    if (widget.editIndex == null) {
      products.add(product);
    } else {
      products[widget.editIndex!] = product;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Товар сохранён")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Карточка товара")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView( // ListView handles scrolling for keyboard/small screens
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Название товара"),
            ),
            TextField(
              controller: buyPriceController,
              decoration: const InputDecoration(labelText: "Цена покупки"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: sellPriceController,
              decoration: const InputDecoration(labelText: "Цена продажи"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: qtyController,
              decoration: const InputDecoration(labelText: "Количество на складе"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Описание"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: const Text("Сохранить"),
            )
          ],
        ),
      ),
    );
  }
}

// Экран регистрации продажи
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Выберите товар")),
      );
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
        SnackBar(content: Text("Недостаточно товара: доступно ${product['qty']}")),
      );
      return;
    }

    setState(() {
      product['qty'] = (product['qty'] as int) - qty;
      sales.add(<String, dynamic>{
        'product': product['name'],
        'qty': qty,
        'profit': ((product['sellPrice'] as double) - (product['buyPrice'] as double)) * qty,
        'date': DateTime.now(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Продажа зарегистрирована")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Регистрация продажи")),
      body: products.isEmpty
          ? const Center(child: Text("Нет товаров для продажи. Добавьте товары."))
          : SingleChildScrollView( // Added SingleChildScrollView to prevent overflow
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  DropdownButton<int>(
                    hint: const Text("Выберите товар"),
                    isExpanded: true,
                    value: selectedIndex,
                    items: List<DropdownMenuItem<int>>.generate( // Specified generic type
                      products.length,
                      (int i) => DropdownMenuItem<int>(
                        value: i,
                        child: Text(products[i]['name'].toString()), // Ensure text is string
                      ),
                    ),
                    onChanged: (int? val) { // Specified parameter type
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

List<Map<String, dynamic>> expenses = [];

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
                    subtitle:
                        Text("Сумма: ${expenses[index]['amount'].toStringAsFixed(2)} ₸"),
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

// Экран отчётов
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
                leading: Icon(Icons.account_balance_wallet,
                    color: netProfit >= 0 ? Colors.blue : Colors.red),
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
              child: Text("Топ продаваемых товаров:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ...topProducts.entries.map((e) {
              double percent = e.value /
                  (topProducts.values.fold(0, (a, b) => a + b));
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
              child: Text("Последние расходы:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ...expenses.reversed.take(3).map((e) => ListTile(
                  leading: Icon(Icons.remove_circle, color: Colors.red),
                  title: Text(e['description']),
                  trailing: Text("${e['amount']} ₸"),
                )),
          ],
        ),
      ),
    );
  }
}
