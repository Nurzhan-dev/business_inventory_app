import 'package:flutter/material.dart';
import '../data/global_data.dart'; // Import global data
import 'product_detail_screen.dart';

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
                int qty = product['qty'] as int;

                // Базовая информация
                String subtitleText =
                    "Цена: ${product['sellPrice']}₸ | Кол-во: $qty";

                // Добавляем предупреждение
                if (qty <= 10) {
                  subtitleText += " ⚠️ Осталось мало!";
                }

                return ListTile(
                  title: Text(product['name'] as String),
                  subtitle: Text(
                    subtitleText,
                    style: TextStyle(
                      color: qty <= 10 ? Colors.red : Colors.black,
                      fontWeight: qty <= 10
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
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
