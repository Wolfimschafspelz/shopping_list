import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_list/model/shopping_list.dart';
import 'package:shopping_list/view/loading_view.dart';

class TemplateTile extends StatelessWidget {
  final String title;
  final List<IconButton> trailingButtons;
  const TemplateTile({Key? key, required this.title, required this.trailingButtons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context, title);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: trailingButtons,
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

    if (!jsonFile.existsSync()) {
      return [];
    }

    String contents = await jsonFile.readAsString(encoding: utf8);

    if (contents.isEmpty) {
      return [];
    }

    final parsed = jsonDecode(contents).cast<Map<String, dynamic>>();

    return parsed.map<ShoppingListModel>((json) => ShoppingListModel.fromJson(json)).toList();
  }

  List<TemplateTile> generateContent(AsyncSnapshot snapshot) {
    List<TemplateTile> result = [];

    for(ShoppingListModel item in snapshot.data) {
      result.add(TemplateTile(title: item.name, trailingButtons: [
        IconButton(
          onPressed: () {}, icon: const Icon(Icons.edit)
        ),
        IconButton(
            onPressed: () {
              setState(() {
                deleteTemplate(item.name, snapshot);
              });
            }, icon: const Icon(Icons.delete)),
      ],));
    }

    return result;
  }

  void deleteTemplate(String title, AsyncSnapshot snapshot) async {
    snapshot.data.removeWhere((item) => item.name == title);

    //remove template's json file
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    File jsonFile = File('$path/templates/' + title + '.json');
    jsonFile.deleteSync(recursive: false);

    jsonFile = File('$path/templates.json');

    List<Map<String, dynamic>> toEncode = [];
    for (var item in snapshot.data) {
      toEncode.add(item.toJson());
    }
    jsonFile.writeAsString(json.encode(toEncode));
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
