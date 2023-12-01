// recipe_data.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:prj1/adminpages/models/model.dart';

ValueNotifier<List<Recipe>> recipenotifier = ValueNotifier([]);

Future<void> addRecipe(Recipe values) async {
  final recipeBox = await Hive.openBox<Recipe>('recipes');
  await recipeBox.add(values);
}

Future<List<Recipe>> getRecipes() async {
  final recipeBox = await Hive.openBox<Recipe>('recipes');
  return recipeBox.values.toList();
}

Future<int> getKey(Recipe recipiesToGetKey) async {
  final recipeBox = await Hive.openBox<Recipe>('recipes');
  final key =
      recipeBox.keyAt(recipeBox.values.toList().indexOf(recipiesToGetKey));
  return key;
}

Future<void> updateRecipe(Recipe rrecipe, int key) async {
  var recipeBox = await Hive.openBox<Recipe>('recipes');
  await recipeBox.put(key, rrecipe);
}

Future<void> deleteRecipe(int key) async {
  final recipeBox = await Hive.openBox<Recipe>('recipes');

  if (recipeBox.isEmpty) {
    print('The recipes box is empty. Cannot delete.');
    return;
  }

  if (key < 0 || key >= recipeBox.length) {
    print('Invalid key. Cannot delete recipe at index $key.');
    return;
  }

  await recipeBox.deleteAt(key);
}

Future<void> fetchRecipesByCategory({required String categoryofFood}) async {
  final box = await Hive.openBox<Recipe>('recipes');

  final categryList = box.values
      .toList()
      .where((food) =>
          food.category.toLowerCase() == categoryofFood.toLowerCase())
      .toList();
  recipenotifier.value = categryList.toList();
  recipenotifier.notifyListeners();
}