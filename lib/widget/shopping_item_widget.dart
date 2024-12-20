import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_item.dart';

class ShoppingItemWidget extends StatefulWidget {
  final ShoppingItem item;
  final Function onPressedDelete;

  const ShoppingItemWidget(this.item, this.onPressedDelete, {super.key});

  @override
  State<ShoppingItemWidget> createState() => _ShoppingItemWidgetState();
}

class _ShoppingItemWidgetState extends State<ShoppingItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextField(
          onChanged: (value){
            setState(() {
              widget.item.name = value;
            });
          },
        ),

        Checkbox(
          value: widget.item.bought,
          onChanged: (value) {
            setState(() {
              widget.item.bought = value!;
            });
          },
        ),

        IconButton(
          icon: Icon(Icons.delete),
          onPressed: widget.onPressedDelete(),
        ),
      ],
    );
  }
}