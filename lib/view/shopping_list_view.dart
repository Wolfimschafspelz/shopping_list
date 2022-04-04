import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_item.dart';
import 'package:shopping_list/model/shopping_list.dart';
import 'shopping_item_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class ShoppingListView extends StatefulWidget {
  final ShoppingListModel initialList;

  const ShoppingListView({Key? key, required this.initialList})
      : super(key: key);

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  String itemName = '';
  late ShoppingListModel list;

  @override
  initState() {
    list = widget.initialList;
    super.initState();
  }

  Future<String> get _localPath async {
    Directory dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    String path = await _localPath;
    return File('$path/shopping_lists.json').create(recursive: true);
  }

  Future<File> get _templateFile async {
    String path = await _localPath;
    return File('$path/templates.json').create(recursive: true);
  }

  void saveList() async {
    File jsonFile = await _localFile;

    String contents = jsonFile.readAsStringSync();

    final toEncode =
        contents.isEmpty ? [] : jsonDecode(contents);

    toEncode.removeWhere((element) => element['name'] == list.name);

    toEncode.add(list.toJson());
    jsonFile.writeAsString(json.encode(toEncode));
  }

  void saveAsTemplate() async {
    File templates = await _templateFile; //open templates.json
    String contents = await templates.readAsString(encoding: utf8);

    //get data to store in file
    final toEncode = (contents.isEmpty) ? [] : jsonDecode(contents).cast<Map<String, dynamic>>();

    //update current template
    toEncode.removeWhere((element) => element['name'] == list.name);
    toEncode.add(list.toJson());

    templates.writeAsString(json.encode(toEncode)); //save result
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(list.name),
          /*leading: BackButton(onPressed: (){
            saveList();
          }),*/

          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save as template',
              onPressed: () {
                saveAsTemplate();
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
                    itemCount: list.items.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, index) {
                      return ShoppingItemWidget(item: list.items[index]);
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
                            list.items.removeWhere(
                                (element) => element.bought == true);
                          });
                          saveList();
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
                            list.items.add(toInsert);
                          });
                          saveList();
                        },
                        child: const Icon(Icons.add)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void deactivate() {
    saveList();
    super.deactivate();
  }
}
