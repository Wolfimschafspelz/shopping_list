import 'package:flutter/material.dart';
import 'package:shopping_list/view/loading_view.dart';
import '../model/shopping_item.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class ShoppingItemWidget extends StatefulWidget {
  final ShoppingItem item;

  const ShoppingItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemViewState();
}

class _ItemViewState extends State<ShoppingItemWidget> {
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

class ShoppingListWidget extends StatefulWidget {
  final String listName;

  const ShoppingListWidget({Key? key, required this.listName}) : super(key: key);

  @override
  State<ShoppingListWidget> createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {

  Future<File> openJsonFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    String fileName = widget.listName.replaceAll(RegExp('\\s+'), '_');

    return File('$path/$fileName.json').create(recursive: true);
  }

  List<ShoppingItem> getItems(String jsonContents) {
    if (jsonContents.isEmpty) {
      return [];
    }

    final parsed = jsonDecode(jsonContents).cast<Map<String, dynamic>>();

    return parsed.map<ShoppingItem>((json) => ShoppingItem.fromJson(json)).toList();
  }

  Future<List<ShoppingItem>> readJson() async {
    File jsonFile = await openJsonFile();
    String contents = await jsonFile.readAsString(encoding: utf8);

    return getItems(contents);
  }

  void saveList(List<ShoppingItem> items) async {
    File jsonFile = await openJsonFile();
    List<Map<String, dynamic>> toEncode = [];
    for (var item in items) {
      toEncode.add(item.toJson());
    }
    jsonFile.writeAsString(json.encode(toEncode));
  }

  String itemName = '';

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
                        return ShoppingItemWidget(item: snapshot.data[index]);
                      },
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                        ),

                        onPressed: () {
                          setState(() {
                            snapshot.data.removeWhere((element) =>
                            element.bought == true);
                          });
                          saveList(snapshot.data);
                        },
                        child: const Text('-')
                      ),

                      Flexible(
                        child: TextField(
                          showCursor: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'item name',
                          ),

                          onChanged: (String value) {
                            itemName = value;
                          },
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                        ),

                        onPressed: () {
                          if (itemName == '') {
                            return;
                          }

                          setState(() {
                            ShoppingItem toInsert = ShoppingItem(
                                false, itemName, null);
                            snapshot.data.add(toInsert);
                          });
                          saveList(snapshot.data);
                        },

                        child: const Text('+')),
                    ],
                  ),
                ),
              ],
          );
        }
        else {
          return const LoadingScreen();
        }
      },
    );
  }
}
