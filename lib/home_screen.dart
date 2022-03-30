import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_list/add_list_form.dart';
import 'package:shopping_list/list_model.dart';
import 'package:shopping_list/list_page.dart';
import 'package:shopping_list/loading_screen.dart';
import 'package:shopping_list/settings_view.dart';

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
  Future<File> openJsonFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    return File('$path/shopping_lists.json').create(recursive: true);
  }

  List<ShoppingListModel> getItems(String jsonContents) {
    if (jsonContents.isEmpty) {
      return [];
    }

    final parsed = jsonDecode(jsonContents).cast<Map<String, dynamic>>();

    return parsed
        .map<ShoppingListModel>((json) => ShoppingListModel.fromJson(json))
        .toList();
  }

  Future<List<ShoppingListModel>> readJson() async {
    File jsonFile = await openJsonFile();
    String contents = await jsonFile.readAsString(encoding: utf8);

    return getItems(contents);
  }

  void saveItem(AsyncSnapshot snapshot) async {
    File jsonFile = await openJsonFile();

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
          'My shopping list',
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
          route: ShoppingListPage(
            name: item.name,
          ),

          trailingButtons: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            IconButton(onPressed: () {
              setState(() {

                saveItem(snapshot);
              });
            }, icon: const Icon(Icons.delete)),
          ],
        )
      );
    }

    result.add(const ShoppingListTile(
      title: 'Settings',
      route: SettingsView(),
      icon: Icon(Icons.settings),
    ));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJson(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My shopping list'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Add new list',
                    onPressed: () {
                      _awaitFormResult(context, snapshot);
                    },
                  ),
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: drawerContent(snapshot),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: LoadingScreen(),
              ),
            );
          }
        });
  }

  void _awaitFormResult(BuildContext context, AsyncSnapshot snapshot) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddListForm(items: snapshot.data)));

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
}
