import 'package:flutter/material.dart';
import 'package:forms/models/grocery_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({
    super.key,
    required this.groceryItems,
    required this.onRemove,
    required this.isloading,
    required this.error,
  });
  final List<GroceryItem> groceryItems;
  final void Function(GroceryItem item) onRemove;
  final bool isloading;
  final error;

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        "There are no Grocery Items",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
    );

    if (widget.isloading) {
      content = Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      );
    }

    if (widget.groceryItems.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: widget.groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            onDismissed: (direction) {
              widget.onRemove(widget.groceryItems[index]);
            },
            key: ValueKey(widget.groceryItems[index].id),
            child: ListTile(
              leading: Container(
                height: 28,
                width: 28,
                color: widget.groceryItems[index].category.color,
              ),
              title: Text(
                widget.groceryItems[index].name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      letterSpacing: 0.2,
                    ),
              ),
              trailing: Text(
                widget.groceryItems[index].quantity.toString(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      letterSpacing: 0.2,
                    ),
              ),
            ),
          );
        },
      );
    }

    if (widget.error != null) {
      content = Center(
        child: Text(widget.error!,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground)),
      );
    }

    return content;
  }
}
