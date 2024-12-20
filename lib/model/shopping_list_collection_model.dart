import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_list.dart';

class ShoppingListCollectionModel with ChangeNotifier {
  final List<ShoppingList> _lists = [];

  List<ShoppingList> get lists => _lists;

  void addList(ShoppingList list) {
    _lists.add(list);
    notifyListeners();
  }

  void editList(int index, ShoppingList newList) {
    _lists[index] = newList;
    notifyListeners();
  }

  void removeList(int index) {
    _lists.removeAt(index);
    notifyListeners();
  }
}