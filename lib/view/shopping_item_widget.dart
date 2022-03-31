import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_item.dart';

class ShoppingItemWidget extends StatefulWidget {
  final ShoppingItem item;

  const ShoppingItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ShoppingItemWidget> {
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