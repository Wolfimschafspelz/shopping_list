import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_list.dart';
import 'package:shopping_list/page/edit_item_page.dart';
import 'package:shopping_list/widget/list_tile/shopping_item_tile.dart';

class ShoppingListPage extends StatefulWidget {
  final ShoppingList list;

  const ShoppingListPage(this.list, {super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => ShoppingItemTile(
                widget.list.items[index],
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EditItemPage(widget.list.items[index])));

                  setState(() {});
                },
              ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: widget.list.items.length),
    );
  }
}
