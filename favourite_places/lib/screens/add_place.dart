import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/user_places.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  PlaceLocation? location;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  // Save Place
  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      final enteredTitle = _titleController.text;

      if (enteredTitle.isEmpty || _selectedImage == null || location == null) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                content: Text(
                  "Please filled all details",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Okay",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                    ),
                  )
                ],
              );
            });
        return;
      }

      ref
          .read(userPlacesProvider.notifier)
          .addPlace(enteredTitle, _selectedImage!, location!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Place"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20,
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.length > 50 ||
                      value.length <= 2) {
                    return "Please Enter a valid title";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ImageInput(
                image: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              LocationInput(
                onSelectLocation: (pickedLocation) {
                  location = pickedLocation;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text("Add Place"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
