import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_list.dart';

class EditListForm extends StatefulWidget {
  final List<ShoppingListModel> items;

  const EditListForm({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormState();
}

class _FormState extends State<EditListForm> {
  bool changed = false;
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  String? listName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit list'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Shopping list name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.toLowerCase() == 'shopping lists') {
                  return 'invalid input';
                }

                for (ShoppingListModel item in widget.items) {
                  if (item.name == value) {
                    return 'List already exists';
                  }
                }

                listName = value;
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, listName);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}