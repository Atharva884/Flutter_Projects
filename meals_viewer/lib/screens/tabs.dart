import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_viewer/providers/favourite_providers.dart';
import 'package:meals_viewer/providers/filters_provider.dart';
import 'package:meals_viewer/screens/categories.dart';
import 'package:meals_viewer/screens/filters.dart';
import 'package:meals_viewer/screens/meals.dart';
import 'package:meals_viewer/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int activeIndex = 0;

  void _changeIndex(index) {
    setState(() {
      activeIndex = index;
    });
  }

  void setScreen(String indentifier) async {
    Navigator.pop(context);
    if (indentifier == "filters") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = ref.watch(moreFilters);

    Widget activeScreen = CategoriesScreen(
      moreFilteredMeals: filteredMeals,
    );
    String activeAppBarTitle = "Categories";

    if (activeIndex == 1) {
      final favouriteMeals = ref.watch(favouriteProviders);
      activeScreen = MealsScreen(
        meals: favouriteMeals,
      );
      activeAppBarTitle = "My favourites";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          activeAppBarTitle,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
      body: activeScreen,
      drawer: MainDrawer(
        onSelectScreen: setScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _changeIndex,
        currentIndex: activeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favourites",
          ),
        ],
      ),
    );
  }
}
