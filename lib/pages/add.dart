import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Add extends StatefulWidget {
  final Map? todo;
  const Add({super.key, this.todo});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo["title"];
      final description = todo["description"];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit" : "Add page"),
      ),
      body: Visibility(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEdit ? editTask : addTask,
              child: Text(isEdit ? "Save" : "Add task"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> editTask() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo["_id"];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        "content-type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      showSnackBarMessage("Failed to add");
    }
  }

  Future<void> addTask() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        "content-type": "application/json",
      },
    );

    if (response.statusCode == 201) {
      titleController.text = "";
      descriptionController.text = "";

      Navigator.pop(context);
    } else {
      showSnackBarMessage("Failed to add");
    }
  }

  void showSnackBarMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
