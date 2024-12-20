import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_list.dart';
import 'package:shopping_list/model/shopping_list_collection_model.dart';
import 'package:shopping_list/page/shopping_list_page.dart';
import 'package:shopping_list/widget/list_tile/shopping_list_tile.dart';

class HomePage extends StatefulWidget {
  final String title;
  final ShoppingListCollectionModel listNotifier;

  const HomePage({
    super.key,
    required this.title,
    required this.listNotifier,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String value;

  void addShoppingList(String name) {
    if (value != '') {
      ShoppingList toAdd = ShoppingList('1', '1', value);
      widget.listNotifier.addList(toAdd);
    }
  }

  @override
  void initState() {
    super.initState();

    value = '';
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final List<ShoppingList> lists = widget.listNotifier.lists;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: ListenableBuilder(
        listenable: ShoppingListCollectionModel(),
        builder: (context, child) => ListView.separated(
          itemBuilder: (context, index) {
            return ShoppingListTile(
              lists[index],
              onPressedDelete: () {
                setState(() {
                  widget.listNotifier.removeList(index);
                });
              },
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ShoppingListPage(lists[index])));

                setState(() {});
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: lists.length,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: controller,
                onChanged: (value) {
                  this.value = value;
                },
                onSubmitted: (value) {
                  setState(() {
                    addShoppingList(value);
                    this.value = '';
                    controller.clear();
                  });
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    addShoppingList(value);
                    value = '';
                    controller.clear();
                  });
                },
                icon: Icon(Icons.add))
          ],
        ),
      ),
    );
  }
}
