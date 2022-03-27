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

  Future<File> openJsonFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    return File('$path/items.json');
  }

  Future<List<ShoppingItem>> readJson() async {
    File jsonFile = await openJsonFile();
    String contents = await jsonFile.readAsString(encoding: utf8);
    var jsonResponse = await jsonDecode(contents);

    List<ShoppingItem> result = [];

    for (var elem in jsonResponse) {
      ShoppingItem item = ShoppingItem.fromJson(elem);
      result.add(item);
    }

    return result;
  }

  void saveList(AsyncSnapshot snapshot) async {
    File jsonFile = await openJsonFile();
    List<Map<String, dynamic>> toEncode = [];
    for (var item in snapshot.data) {
      toEncode.add(item.toJson());
    }
    jsonFile.writeAsString(json.encode(toEncode));
  }

  @override
  void initState() {
    super.initState();
  }

  String name = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readJson(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, index) {
                        return ShoppingItemView(item: snapshot.data[index]);
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
                            setState(() {
                              snapshot.data.removeWhere((element) =>
                              element.bought == true);
                              saveList(snapshot);
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
                              ShoppingItem toInsert = ShoppingItem(
                                  false, name, 0);
                              snapshot.data.add(toInsert);
                              saveList(snapshot);
                            });
                          },
                          child: const Text('+')),
                    ],
                  ),
                ),
              ],
          );
        }
        else {
          return const Text('Loading...');
        }
      },
    );
  }
}
