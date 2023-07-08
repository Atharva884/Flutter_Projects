import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forms/data/categories.dart';
import 'package:forms/models/category.dart';
import 'package:forms/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  var formKey = GlobalKey<FormState>();

  var _selectedCategory = categories[Categories.vegetables]!;
  String _name = "";
  String _quantitiy = "1";

  var isSending = false;

  void postItem() async {
    setState(() {
      isSending = true;
    });

    // Posting data to database
    final url = Uri.https("flutter-crud-55dd4-default-rtdb.firebaseio.com",
        "/shopping-list.json");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "name": _name,
          "quantity": _quantitiy,
          "category": _selectedCategory.title
        },
      ),
    );

    final Map<String, dynamic> decodedData = jsonDecode(response.body);

    if (context.mounted) {
      Navigator.of(context).pop(
        GroceryItem(
          id: decodedData.toString(),
          name: _name,
          quantity: int.parse(_quantitiy),
          category: _selectedCategory,
        ),
      );
    }
  }

  void _submitItem() {
    if (formKey.currentState!.validate()) {
      // This will call validator() method, and return true

      // This if will execute when it is validated
      formKey.currentState!
          .save(); // This will automatically call onSaved() method of formfields

      postItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text("Name")),
                autofocus: true,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length > 50 ||
                      value.trim().length < 3) {
                    return "Enter a Valid Name between 2 - 50";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  // Can't be null as we have checked above
                  _name = newValue!;
                },
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _quantitiy,
                      decoration: const InputDecoration(
                        label: Text("Quantitiy"),
                      ),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0 ||
                            int.tryParse(value)! > 100) {
                          return "Please, Enter a valid quantity";
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        // Can't be null as we have checked above
                        _quantitiy = newValue!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  category.value.title,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                )
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            formKey.currentState!.reset();
                            setState(() {
                              _selectedCategory =
                                  categories[Categories.vegetables]!;
                            });
                          },
                    child: const Text("Reset"),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: isSending ? null : _submitItem,
                    child: isSending
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          )
                        : Text(
                            "Save Item",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
