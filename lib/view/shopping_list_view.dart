import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_item.dart';
import 'package:shopping_list/model/shopping_list.dart';
import 'shopping_item_widget.dart';
import 'package:shopping_list/view/loading_view.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class ShoppingListView extends StatefulWidget {
  final String name;

  const ShoppingListView({Key? key, required this.name}) : super(key: key);

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  String itemName = '';

  Future<File> openJsonFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    String fileName = widget.name.replaceAll(RegExp('\\s+'), '_');

    return File('$path/$fileName.json').create(recursive: true);
  }

  List<ShoppingItem> getItems(String jsonContents) {
    if (jsonContents.isEmpty) {
      return [];
    }

    final parsed = jsonDecode(jsonContents).cast<Map<String, dynamic>>();

    return parsed
        .map<ShoppingItem>((json) => ShoppingItem.fromJson(json))
        .toList();
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

  void saveAsTemplate(List<ShoppingItem> items) async {
    //create json file to store lists content as template
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/templates';
    File template = await File('$path/' + widget.name + '.json').create(recursive: true);

    //update templates.json
    path = dir.path;
    File templates = await File('$path/templates.json').create(recursive: true);
    String contents = await templates.readAsString(encoding: utf8);
    List<Map<String, dynamic>> toEncodeTemplate = (contents.isEmpty) ? [] : jsonDecode(contents).cast<Map<String, dynamic>>();
    toEncodeTemplate.add(ShoppingListModel(widget.name).toJson());
    templates.writeAsString(json.encode(toEncodeTemplate));


    //fill template's json file with list's elements
    List<Map<String, dynamic>> toEncode = [];
    for (var item in items) {
      toEncode.add(item.toJson());
    }

    template.writeAsString(json.encode(toEncode));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readJson(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.name),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.save),
                    tooltip: 'Save as template',
                    onPressed: () {
                      saveAsTemplate(snapshot.data);
                    },
                  ),
                ],
              ),
              body: Center(
                child: Stack(
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
                            return ShoppingItemWidget(
                                item: snapshot.data[index]);
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
                                  snapshot.data.removeWhere(
                                      (element) => element.bought == true);
                                });
                                saveList(snapshot.data);
                              },
                              child: const Icon(Icons.remove)),
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
                                  ShoppingItem toInsert =
                                      ShoppingItem(false, itemName, null);
                                  snapshot.data.add(toInsert);
                                });
                                saveList(snapshot.data);
                              },
                              child: const Icon(Icons.add)),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        } else {
          return const LoadingView();
        }
      },
    );
  }
}
