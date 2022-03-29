import 'package:flutter/material.dart';

class AddListForm extends StatefulWidget {
  const AddListForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormState();
}

class _FormState extends State<AddListForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  String? listName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new list'),
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
                if (value == null || value.isEmpty || value.toLowerCase() == 'shopping lists') {
                  return 'invalid input';
                }

                listName = value;
                return null;
              },
            ),

            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(listName!)),
                  );
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