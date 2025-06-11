// pubspec.yaml ထဲမှာ http package ထည့်မယ်
// dependencies:
//   flutter:
//     sdk: flutter
//   http: ^0.13.5

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

/// MyApp: root widget for the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Set the home page of the application to ProductListPage.
      home: ProductListPage(),
    );
  }
}

/// Product model: Represents a single product with its properties.
class Product {
  final int id;
  final String name;
  final String imageUrl;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.inStock,
  });

  /// Factory constructor to create a Product object from a JSON map.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      inStock: json['inStock'],
    );
  }
}

/// ProductListPage: A StatefulWidget responsible for displaying a paginated list of products.
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

/// State class for ProductListPage, handling data fetching and UI updates.
class _ProductListPageState extends State<ProductListPage> {
  // ScrollController to detect when the user scrolls to the end of the list.
  final ScrollController _scrollController = ScrollController();

  List<Product> _products = []; // List to hold fetched products.
  int _page = 1; // Current page number for pagination.
  final int _limit = 10; // Number of items to fetch per page.
  bool _isLoading = false; // Flag to indicate if data is currently being loaded.
  bool _hasMore = true; // Flag to indicate if there are more pages to load.
  String? _errorMessage; // Stores any error message that occurs during fetching.

  // The API endpoint for fetching product data.
  static const String apiUrl = 'https://crawl-scrape-test-website.vercel.app/api_pagi';

  @override
  void initState() {
    super.initState();
    _fetchPage(); // Fetch the initial page of products when the widget is initialized.
    _scrollController.addListener(_onScroll); // Add a listener to detect scroll events.
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the ScrollController to prevent memory leaks.
    super.dispose();
  }

  /// Listener for the ScrollController.
  /// Fetches more data when the user scrolls near the end of the list,
  /// provided that no loading is in progress and there are more pages available.
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 && // 200 pixels from the end
        !_isLoading &&
        _hasMore) {
      _fetchPage();
    }
  }

  /// Asynchronously fetches a page of product data from the API.
  Future<void> _fetchPage() async {
    // If already loading, return immediately to prevent duplicate requests.
    if (_isLoading) return;

    setState(() {
      _isLoading = true; // Set loading flag to true.
      _errorMessage = null; // Clear any previous error messages.
    });

    // Construct the URI with current page and limit parameters.
    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'page': '$_page',
      'limit': '$_limit',
    });

    try {
      final response = await http.get(uri); // Perform the HTTP GET request.

      if (response.statusCode == 200) {
        // If the request is successful (status code 200).
        final jsonBody = json.decode(response.body); // Decode the JSON response body.
        final List<dynamic> data = jsonBody['data']; // Extract the product data array.
        // Convert JSON data to a list of Product objects.
        final fetched = data.map((e) => Product.fromJson(e)).toList();

        setState(() {
          _page++; // Increment page number for the next fetch.
          _products.addAll(fetched); // Add newly fetched products to the existing list.
          // Determine if there are more pages by comparing current page with total pages.
          _hasMore = _page <= (jsonBody['totalPages'] as int);
        });
      } else {
        // If the response status code is not 200, throw an exception.
        throw Exception('Failed to load products: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Catch any errors during the HTTP request or JSON decoding.
      setState(() {
        _errorMessage = e.toString(); // Store the error message.
      });
    } finally {
      // This block always executes, regardless of success or failure.
      setState(() {
        _isLoading = false; // Set loading flag to false.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Pagination')),
      body: Column(
        children: [
          Expanded(
            child: _buildListView(), // Display the list of products.
          ),
          // Show a circular progress indicator at the bottom when loading.
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          // Show an error message if one exists.
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Error: $_errorMessage',
                  style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  /// Builds the ListView for displaying products.
  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController, // Attach the scroll controller.
      itemCount: _products.length, // Number of items in the list.
      itemBuilder: (context, index) {
        final p = _products[index]; // Get the product at the current index.
        print('Attempting to load image for ${p.name} from URL: ${p.imageUrl}'); // Log the image URL for debugging

        return ListTile(
          leading: Image.network(
            p.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            // Displays a CircularProgressIndicator while the image is loading.
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child; // Image is fully loaded, show the image.
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null, // Value is null if total bytes are unknown.
                ),
              );
            },
            // Displays a broken image icon and "Failed" text if the image fails to load.
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[200], // Light grey background for failed image.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.broken_image,
                      size: 25, // Icon size.
                      color: Colors.grey, // Icon color.
                    ),
                    Text(
                      'Failed', // Text to indicate image loading failed.
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    )
                  ],
                ),
              );
            },
          ),
          title: Text(p.name), // Product name.
          subtitle: Text(p.inStock ? 'In Stock' : 'Out of Stock'), // Stock status.
        );
      },
    );
  }
}
