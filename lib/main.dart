import 'package:flipkart_test/view/productlisting.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Listing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListingPage(),
    );
  }
}
