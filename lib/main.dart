import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MyListView(),
    );
  }
}


class Product {
  final String name;
  final String category;
  final double price;
  final int stock;

  Product({required this.name, required this.category, required this.price, required this.stock});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      stock: json['stock'].toInt(),
    );
  }
}

class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<Product>? productList;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      String data = await DefaultAssetBundle.of(context).loadString('assets/produk.json');
      final jsonResult = json.decode(data);
      if (jsonResult != null && jsonResult['products'] != null) {
        setState(() {
          productList = (jsonResult['products'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();
        });
      } else {
        throw Exception("Invalid JSON format or empty products list");
      }
    } catch (e) {
      print("Error loading products: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: productList == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: productList!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(productList![index].name),
            subtitle: Text('Category: ${productList![index].category}, Price: \$${productList![index].price.toStringAsFixed(2)}'), // Menggunakan null assertion operator (!)
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: productList![index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Product Name: ${product.name}'),
            Text('Category: ${product.category}'),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            // Add more details here as needed
          ],
        ),
      ),
    );
  }
}
