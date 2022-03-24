import 'package:flutter/material.dart';
import 'package:shopping_list/shopping_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shopping List',
      home: Scaffold(
        body: Center(
          child: ShoppingListView(),
        ),
      ),
    );
  }
}