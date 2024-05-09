import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Product Listing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListingPage(),
    );
  }
}

class ProductListingPage extends StatefulWidget {
  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  _fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      setState(() {
        _products = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,
        title: Text('Flipkart',style: TextStyle(
          color: Colors.yellow
        ),),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: _products[index],
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              product['image'],
              fit: BoxFit.cover, 
            ),
          ),
          Text(product['title']),
          Text('Price: \$${product['price']}'),
          Text('Category: ${product['category']}'),
          Text('Rating: ${product['rating']['rate']}'),
        ],
      ),
    );
  }
}