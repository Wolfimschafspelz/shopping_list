import 'package:flutter/material.dart';
import 'shopping_item.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class ShoppingListElement extends StatefulWidget {
  final ShoppingItem item;

  const ShoppingListElement({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElementState();
}

class _ElementState extends State<ShoppingListElement> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget.item.bought,
            onChanged: (bool? state) {
              setState(() {
                widget.item.bought = state;
              });
            }),
        Text(widget.item.name),
      ],
    );
  }
}

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({Key? key}) : super(key: key);

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  List<ShoppingListElement> items = [];

  _ShoppingListViewState() {
    readItems();
  }

  readItems() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    File jsonFile = File('$path/items.json');

    String contents = jsonFile.readAsStringSync(encoding: utf8);
    var jsonResponse = jsonDecode(contents);

    for (var elem in jsonResponse) {
      ShoppingItem item = ShoppingItem(elem['bought'], elem['name'], elem['amount']);
      ShoppingListElement element = ShoppingListElement(item: item);
      items.add(element);
    }
  }

  void saveList() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    File jsonFile = File('$path/items.json');

    List<Map<String, dynamic>> toEncode = [];
    for (var item in items) {
      toEncode.add(item.item.toJson());
    }
    jsonFile.writeAsString(json.encode(toEncode));
  }

  String name = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, index) {
                return items[index];
              },
            ),
          ),
        ),


        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState((){
                    items.removeWhere((element) => element.item.bought == true);
                    saveList();
                  });
                },
                child: const Text('-')
            ),

            Flexible(
              child: TextField(
                showCursor: true,
                onChanged: (String value) {
                  name = value;
                },
              ),
            ),

            ElevatedButton(
                onPressed: () {
                  if (name == '') {
                    return;
                  }

                  setState(() {
                    ShoppingItem item = ShoppingItem(false, name, 0);
                    ShoppingListElement toInsert = ShoppingListElement(item: item);
                    items.add(toInsert);
                    saveList();
                  });
                },
                child: const Text('+')),
            ],
          ),
        ),
      ],
    );
  }
}
