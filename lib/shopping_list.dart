import 'package:flutter/material.dart';
import 'shopping_item.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class ShoppingItemView extends StatefulWidget {
  final ShoppingItem item;

  const ShoppingItemView({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemViewState();
}

class _ItemViewState extends State<ShoppingItemView> {
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
  Future<File>? jsonFile;

  List<ShoppingItem> items = [];
  Future<File> openJsonFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    return File('$path/items.json');
  }

  @override
  void initState() {
    setState(() {
      readItems();
    });
    super.initState();
  }

  readItems() async {
    File jsonFile = await openJsonFile();

    String contents = jsonFile.readAsStringSync(encoding: utf8);
    var jsonResponse = jsonDecode(contents);

    for (var elem in jsonResponse) {
      ShoppingItem item = ShoppingItem(elem['bought'], elem['name'], elem['amount']);
      items.add(item);
    }
  }

  void saveList() async {
    File jsonFile = await openJsonFile();

    List<Map<String, dynamic>> toEncode = [];
    for (var item in items) {
      toEncode.add(item.toJson());
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
                return ShoppingItemView(item: items[index]);
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
                    items.removeWhere((element) => element.bought == true);
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
                    ShoppingItem toInsert = ShoppingItem(false, name, 0);
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
