import 'package:flutter/material.dart';
import '../data/global_data.dart'; // Import global data

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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Товар сохранён")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Карточка товара")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          // ListView handles scrolling for keyboard/small screens
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
              decoration: const InputDecoration(
                labelText: "Количество на складе",
              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
