import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_item.dart';

class EditItemWidget extends StatelessWidget {
  final ShoppingItem? item;

  const EditItemWidget({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.cancel),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.save),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
