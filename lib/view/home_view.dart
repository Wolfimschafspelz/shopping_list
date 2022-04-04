import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_list/form/add_from_template_form.dart';
import 'package:shopping_list/form/add_list_form.dart';
import 'package:shopping_list/form/edit_list_form.dart';
import 'package:shopping_list/model/shopping_list.dart';
import 'package:shopping_list/view/shopping_list_view.dart';
import 'package:shopping_list/view/loading_view.dart';

class ShoppingListTile extends StatelessWidget {
  final String title;
  final Icon? icon;
  final Widget route;
  final List<Widget>? trailingButtons;

  const ShoppingListTile(
      {Key? key,
      required this.title,
      required this.route,
      this.icon,
      this.trailingButtons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: (trailingButtons != null)
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: trailingButtons!,
            )
          : null,
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _awaitAddFormResult(BuildContext context, AsyncSnapshot snapshot) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddListForm(items: snapshot.data)));

    if(result == null) {
      return;
    }

    for (ShoppingListModel item in snapshot.data) {
      if (item.name == result.name)  {
        return;
      }
    }

    setState(() {
      snapshot.data.add(result);
      saveItem(snapshot);
    });
  }

  void renameList(String name, ShoppingListModel item, AsyncSnapshot snapshot) async {
    snapshot.data.remove(item);
    snapshot.data.add(ShoppingListModel(name, item.items));
  }

  void _awaitRenameFormResult(BuildContext context, AsyncSnapshot snapshot, ShoppingListModel item) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditListForm(items: snapshot.data)));
    setState(() {
      renameList(result, item, snapshot);
      saveItem(snapshot);
    });
  }

  void deleteList(ShoppingListModel item, AsyncSnapshot snapshot) async {
    snapshot.data.remove(item);
  }

  void _awaitTemplateFormResult(AsyncSnapshot snapshot) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFromTemplateForm()));

    if(result == null) {
      return;
    }

    for (ShoppingListModel item in snapshot.data) {
      if (item.name == result.name)  {
        return;
      }
    }

    setState(() {
      snapshot.data.add(result);
      saveItem(snapshot);
    });
  }

  List<ShoppingListModel> getItems(String jsonContents) {
    if (jsonContents.isEmpty) {
      return [];
    }

    final parsed = jsonDecode(jsonContents);

    return parsed.map<ShoppingListModel>((json) => ShoppingListModel.fromJson(json)).toList();
  }

  Future<String> get _localPath async {
    Directory dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    String path = await _localPath;
    return File('$path/shopping_lists.json').create(recursive: true);
  }

  Future<List<ShoppingListModel>> get _shoppingLists async {
    File jsonFile = await _localFile;
    String contents = await jsonFile.readAsString(encoding: utf8);

    return getItems(contents);
  }

  void saveItem(AsyncSnapshot snapshot) async {
    File jsonFile = await _localFile;

    List<Map<String, dynamic>> toEncode = [];
    for (var i in snapshot.data) {
      toEncode.add(i.toJson());
    }
    jsonFile.writeAsString(json.encode(toEncode));
  }

  List<Widget> drawerContent(AsyncSnapshot snapshot) {
    List<Widget> result = [];

    result.add(
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text(
          'Select List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );

    for (ShoppingListModel item in snapshot.data) {
      result.add(
        ShoppingListTile(
          title: item.name,
          route: ShoppingListView(
            initialList: item,
          ),

          trailingButtons: [
            IconButton(onPressed: () {
              _awaitRenameFormResult(context, snapshot, item);
            }, icon: const Icon(Icons.edit)),

            IconButton(onPressed: () {
              setState(() {
                deleteList(item, snapshot);
                saveItem(snapshot);
              });
            }, icon: const Icon(Icons.delete)),
          ],
        )
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _shoppingLists,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My shopping list'),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: drawerContent(snapshot),
                ),
              ),

              body: Center(
                child: ListView(
                  children: [
                    ElevatedButton(
                      child: const Text('Add new List'),
                      onPressed: () {
                        _awaitAddFormResult(context, snapshot);
                      },
                    ),

                    ElevatedButton(
                      child: const Text('Add List from template'),
                      onPressed: () {
                        _awaitTemplateFormResult(snapshot);
                      },
                    ),
                  ],
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
        });
  }
}