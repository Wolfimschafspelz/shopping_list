import 'package:flutter/material.dart';
import 'package:shopping_list/view/shopping_list_widget.dart';

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

      body: Center(
        child: ShoppingListWidget(listName: widget.name),
      ),
    );
  }
}