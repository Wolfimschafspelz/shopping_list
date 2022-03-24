import 'package:flutter/material.dart';

///Model class to represent items to shop
/// @author Lukas Steinmann <lukas.steinmann@gmx.de>
class ShoppingItem {
  bool? bought;
  final String name;
  final int amount;

  ShoppingItem(this.bought, this.name, this.amount);
}

class ShoppingListElement extends StatefulWidget {
  final ShoppingItem item;

  const ShoppingListElement({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElementState();
}

class _ElementState extends State<ShoppingListElement> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget.item.bought,
            onChanged: (bool? state) {
              setState(() {
                widget.item.bought = state;
              });
            }),
        Text(widget.item.name),
      ],
    );
  }
}

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({Key? key}) : super(key: key);

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  List<ShoppingListElement> items = [];
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, index) {
            return items[index];
          },
        ),
        Row(
          children: [
            Flexible(
              child: TextField(
                showCursor: true,
                onChanged: (String value) {
                  name = value;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    ShoppingItem item = ShoppingItem(false, name, 0);
                    ShoppingListElement toInsert = ShoppingListElement(item: item);
                    items.add(toInsert);
                  });
                },
                child: const Text('+')),
            ElevatedButton(
                onPressed: () {
                  setState((){
                    items.removeWhere((element) => element.item.bought == true);
                  });
                },
                child: const Text('-')),
          ],
        ),
      ],
    );
  }
}
