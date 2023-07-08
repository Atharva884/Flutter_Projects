// Simple Provider for static data which cannot be changed

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_viewer/data/data.dart';

final categoriesProvider = Provider((ref){
  return availableCategories;
});

final mealsProvider = Provider((ref){
  return availableMeals;
});