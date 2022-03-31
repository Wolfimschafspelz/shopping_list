import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_list/model/shopping_list.dart';
import 'package:shopping_list/view/loading_view.dart';

class TemplateTile extends StatelessWidget {
  final String title;
  const TemplateTile({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {},
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.edit)
          ),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }
}

class AddFromTemplateForm extends StatefulWidget {
  const AddFromTemplateForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormState();
}

class _FormState extends State<AddFromTemplateForm> {

  Future<List<ShoppingListModel>> readTemplates() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;

    File jsonFile = File('$path/templates.json');

    String contents = await jsonFile.readAsString(encoding: utf8);

    final parsed = jsonDecode(contents).cast<Map<String, dynamic>>();

    return parsed.map<ShoppingListModel>((json) => ShoppingListModel.fromJson(json)).toList();
  }

  List<TemplateTile> generateContent(AsyncSnapshot snapshot) {
    List<TemplateTile> result = [];

    for(ShoppingListModel item in snapshot.data) {
      result.add(TemplateTile(title: item.name));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readTemplates(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Form(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Create list from template'),
              ),
              body: Center(
                child: ListView(
                  children: generateContent(snapshot),
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: LoadingView(),
            ),
          );
        }
      },
    );
  }
}
