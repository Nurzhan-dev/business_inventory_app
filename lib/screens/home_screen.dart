import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'product_detail_screen.dart';
import 'sales_screen.dart';
import 'reports_screen.dart';
import 'expense_screen.dart';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductListScreen()),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailScreen()),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SalesScreen()),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportsScreen()),
                  );
                } else if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ExpenseScreen()),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
