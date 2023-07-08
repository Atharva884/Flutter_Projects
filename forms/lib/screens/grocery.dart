import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forms/data/categories.dart';
import 'package:forms/models/grocery_item.dart';
import 'package:forms/screens/new_item.dart';
import 'package:forms/widgets/grocery_list.dart';
import 'package:http/http.dart' as http;

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  List<GroceryItem> _groceryItems = [];
  var isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void loadItems() async {
    final url = Uri.https(
        "flutter-crud-55dd4-default-rtdb.firebaseio", "/shopping-list.json");

    try {
      final response = await http.get(url); // Json

      if (response.statusCode >= 400) {
        error = "Failed to fetch data. Please try Again!";
      }

      if (response.body == "null") {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Convert json to map
      final Map<String, dynamic> listData = jsonDecode(response.body);

      final List<GroceryItem> loadedItems = [];

      // looping through map by converting to the list of item
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;

        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: int.parse(item.value['quantity']),
            category: category,
          ),
        );
      }

      // Setting loadedItems to groceryItems
      setState(() {
        _groceryItems = loadedItems;
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        error = "Something went wrong! Try Again Later";
      });
    }
  }

  void onClick(BuildContext context) async {
    final response = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (response == null) {
      return;
    }

    setState(() {
      _groceryItems.add(response);
    });
  }

  void _removeItem(GroceryItem item) async {
    int index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https("flutter-crud-55dd4-default-rtdb.firebaseio.com",
        "shopping-list/${item.id}.json");

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            content: Text(
              "Failed to Delete Item. Please Try Again!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        );
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Groceries",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              onClick(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: GroceryList(
        groceryItems: _groceryItems,
        onRemove: _removeItem,
        isloading: isLoading,
        error: error,
      ),
    );
  }
}
