import 'package:flutter/material.dart';
import 'package:shopping_list/list_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shopping List',
      home: ShoppingListPage(name: 'Test'),
    );
  }
}