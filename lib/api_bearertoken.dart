import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MaterialApp(
    home: CategoriesScreen(),
  ));
}

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Future<List<dynamic>> fetchProductCategories() async {
    final apiUrl =
        'https://service-zedzat.tequevia.com/api/v1/zedzat/product-category/?category_type=product';
    final apiKey =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkwMzUxMDU3LCJqdGkiOiIxN2VmNmY2NWQyMzU0ZTBkYmVhY2U3ZTE3M2EyZTAzZSIsInVzZXJfaWQiOiJkMmQ0NTU0Yi05Yjg4LTQwM2EtOWFmOS0xMDkyYzc1ZmVjZmMifQ.ISlOj9SnDfHrQ2ucmvcvlIdmefyQYl4ngt_Wbf2tL6E'; // Replace 'YOUR_API_KEY' with your actual API key

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $apiKey',
      });

      if (response.statusCode == 200) {
        // Successful response, parse the JSON data
        final jsonData = json.decode(response.body);
        // Return the list of categories
        return jsonData;
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        return []; // Return an empty list in case of an error
      }
    } catch (e) {
      // Handle other errors, e.g., connection issues
      print('Error: $e');
      return []; // Return an empty list in case of an error
    }
  }

  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    List<dynamic> fetchedCategories = await fetchProductCategories();
    setState(() {
      categories = fetchedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Categories')),
      body: _buildCategoryList(),
    );
  }

  Widget _buildCategoryList() {
    if (categories.isEmpty) {
      return Center(
          child:
              CircularProgressIndicator()); // Show a loading indicator while fetching data
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        var category = categories[index];
        return ListTile(
            leading: Text(category['category_name']),
            title: CachedNetworkImage(imageUrl: category['category_image'])

            // You can add more details or customize the ListTile as needed based on your API response
            );
      },
    );
  }
}
