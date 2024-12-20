import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_item.dart';

class EditItemPage extends StatelessWidget {
  final ShoppingItem item;

  const EditItemPage(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: item.name);
    final amountController =
        TextEditingController(text: item.amount.toString());
    final priceController = TextEditingController(text: item.price.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${item.name}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TextField(
              controller: nameController,
              onChanged: (value) {
                item.name = value;
              },
            ),
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    item.amount++;
                    amountController.text = item.amount.toString();
                  },
                  icon: Icon(Icons.add),
                ),
              ),
              Flexible(
                flex: 1,
                child: TextField(
                  controller: amountController,
                  onChanged: (value) {
                    item.amount = double.parse(value);
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    if (item.amount > 0) {
                      item.amount--;
                      amountController.text = item.amount.toString();
                    }
                  },
                  icon: Icon(Icons.remove),
                ),
              ),
              Flexible(
                flex: 1,
                child: DropdownMenu(
                  initialSelection: item.unit,
                  onSelected: (value) {
                    item.unit = value!;
                  },
                  dropdownMenuEntries: Measure.values
                      .map((value) =>
                          DropdownMenuEntry(value: value, label: value.name))
                      .toList(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    item.price++;
                    priceController.text = item.price.toString();
                  },
                  icon: Icon(Icons.add),
                ),
              ),
              Flexible(
                flex: 1,
                child: TextField(
                  controller: priceController,
                  onChanged: (value) {
                    item.price = double.parse(value);
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    if (item.price > 0) {
                      item.price--;
                      priceController.text = item.price.toString();
                    }
                  },
                  icon: Icon(Icons.remove),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
