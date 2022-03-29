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

  const ShoppingListTile({Key? key, required this.title, required this.route, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
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

    return parsed.map<ShoppingListModel>((json) => ShoppingListModel.fromJson(json)).toList();
  }

  Future<List<ShoppingListModel>> readJson() async {
    File jsonFile = await openJsonFile();
    String contents = await jsonFile.readAsString(encoding: utf8);

    return getItems(contents);
  }

  List<Widget> drawerContent(List<ShoppingListModel> lists) {
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

    for(ShoppingListModel item in lists) {
      result.add(ShoppingListTile(title: item.name, route: ShoppingListPage(name: item.name,)));
    }

    result.add(const ShoppingListTile(title: 'Settings', route: SettingsView(), icon: Icon(Icons.settings),));

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
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const AddListForm();
                        },
                      ));
                    },
                  ),
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: drawerContent(snapshot.data!),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.refresh),
                tooltip: 'refresh list',
                onPressed: () => setState(() {}),
              ),
            );
          }
          else {
            return const Scaffold(
              body: Center(
                child: LoadingScreen(),
              ),
            );
          }
        }
    );
  }
}