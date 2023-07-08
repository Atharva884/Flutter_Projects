import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_viewer/providers/meal_category_providers.dart';

enum Filters { glutenfree, lactosefree, vegeterian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filters, bool>> {
  // Here, we initialize initial map i.e key:value pair
  FiltersNotifier()
      : super({
          Filters.glutenfree: false,
          Filters.lactosefree: false,
          Filters.vegeterian: false,
          Filters.vegan: false,
        });

  void setFilters(Map<Filters, bool> filters) {
    state = filters;
  }

  void setFilter(Filters filter, bool isActive) {
    // state[filter] = isActive;  --> Not allowed mutating

    // We create new map, of existing map key:value pair and overriding new key:value pair
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filters, bool>>(
  (ref) => FiltersNotifier(),
);

final moreFilters = Provider(
  (ref) {
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filtersProvider);

    return meals.where((meal) {
      if (activeFilters[Filters.glutenfree]! && !meal.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filters.lactosefree]! && !meal.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filters.vegeterian]! && !meal.isVegetarian) {
        return false;
      }
      if (activeFilters[Filters.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
  },
);
