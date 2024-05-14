import 'package:flipkart_test/model/productmodel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductListingPage extends StatefulWidget {
  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Product> products =
          jsonData.map((json) => Product.fromJson(json)).toList();
          products.sort((a, b) => a.isPinned ? -1 : 1);
         products = products.reversed.toList();
      // products.sort((a, b) => b.isPinned.compareTo(a.isPinned));

      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Flipkart',
          style: TextStyle(color: Colors.yellow),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Product>? products = snapshot.data;
            if (products != null && products.isNotEmpty) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              );
            } else {
              return Center(
                child: Text('No products available'),
              );
            }
          }
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
          ),
          Text(product.title),
          Text('Price: \$${product.price.toStringAsFixed(2)}'),
          Text('Category: ${product.category}'),
          IconButton(
            icon: Icon(product.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () {
              // Toggle pin status
              product.isPinned = !product.isPinned;
              _savePinStatus(product.id, product.isPinned);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(product.isPinned ? 'Product pinned' : 'Product unpinned')),
              );
            },
          ),
        ],
      ),
    );
  }

    void _savePinStatus(int productId, bool isPinned) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('product_$productId', isPinned);
  }
}
