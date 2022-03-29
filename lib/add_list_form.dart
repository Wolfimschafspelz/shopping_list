import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_list/list_model.dart';

class AddListForm extends StatefulWidget {
  const AddListForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormState();
}

class _FormState extends State<AddListForm> {
  bool changed = false;
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  String? listName;

  Future<File> openJsonFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    return File('$path/shopping_lists.json').create(recursive: true);
  }

  void saveItem(ShoppingListModel item) async {
    File jsonFile = await openJsonFile();

    String contents = await jsonFile.readAsString(encoding: utf8);
    final items = (contents.isEmpty)
        ? []
        : jsonDecode(contents)
            .cast<Map<String, dynamic>>()
            .map<ShoppingListModel>((json) => ShoppingListModel.fromJson(json))
            .toList();

    items.add(item);

    List<Map<String, dynamic>> toEncode = [];
    for (var i in items) {
      toEncode.add(i.toJson());
    }
    jsonFile.writeAsString(json.encode(toEncode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new list'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Shopping list name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.toLowerCase() == 'shopping lists') {
                  return 'invalid input';
                }

                listName = value;
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  ShoppingListModel toInsert = ShoppingListModel(listName!);

                  saveItem(toInsert);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('added ' + listName!)),
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
