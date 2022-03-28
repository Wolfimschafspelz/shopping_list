import 'package:flutter/material.dart';
import 'package:shopping_list/selection_screen.dart';
import 'package:shopping_list/shopping_list.dart';

class ShoppingListPage extends StatefulWidget {
  final String name;
  const ShoppingListPage({Key? key, required this.name}) : super(key: key);

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),

      drawer: const SelectionScreen(),

      body: Center(
        child: ShoppingListView(listName: widget.name),
      ),
    );
  }
}