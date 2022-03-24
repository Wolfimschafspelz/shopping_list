import 'package:flutter/material.dart';

///Model class to represent items to shop
/// @author Lukas Steinmann <lukas.steinmann@gmx.de>
class ShoppingItem {
  final String name;
  final int amount;

  ShoppingItem(this.name, this.amount);
}

class ShoppingListElement extends StatefulWidget {
  final ShoppingItem item;

  const ShoppingListElement({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElementState();
}

class _ElementState extends State<ShoppingListElement> {
  bool? bought = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: bought,
            onChanged: (bool? state) {
              setState(() {
                bought = state;
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
  List<ShoppingListElement> items = [
    ShoppingListElement(item: ShoppingItem('Test', 0)),
    ShoppingListElement(item: ShoppingItem('Test2', 0)),
    ShoppingListElement(item: ShoppingItem('Test3', 0))
  ];

  @override
  Widget build(BuildContext context) {
    return Column (
      children: [
        ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, index) {
            return items[index];
          },
        ),

        ElevatedButton(onPressed: (){
          setState(() {
            ShoppingItem item = ShoppingItem('Newly inserted', 0);
            ShoppingListElement toInsert = ShoppingListElement(item: item);
            items.add(toInsert);
          });
        }, child: const Text('+')),
      ],
    );
  }
}
