import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_item.dart';

class ShoppingItemTile extends StatefulWidget {
  final ShoppingItem item;
  final void Function()? onPressedDelete;
  final void Function()? onTap;

  const ShoppingItemTile(this.item,
      {super.key, this.onTap, this.onPressedDelete});

  @override
  State<ShoppingItemTile> createState() => _ShoppingItemTileState();
}

class _ShoppingItemTileState extends State<ShoppingItemTile> {
  String amount(double value, Measure unit) {
    String result = '';
    if ((value - value.truncate()) != 0) {
      result += value.toStringAsFixed(3);
    } else {
      result += value.toStringAsFixed(0);
    }

    if (unit != Measure.none) {
      result += ' ${unit.name}';
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      leading: Checkbox(
        value: widget.item.bought,
        onChanged: (value) {
          setState(() {
            widget.item.bought = value!;
          });
        },
      ),
      title: Center(
        child: Text(widget.item.name),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(amount(widget.item.amount, widget.item.unit)),
          const Divider(),
          Text('${widget.item.price.toStringAsFixed(2)}€'),
        ],
      ),
      trailing: IconButton(
        onPressed: widget.onPressedDelete,
        icon: Icon(Icons.delete),
      ),
    );
  }
}
