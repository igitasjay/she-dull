import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:she_dull/pages/add.dart';
import 'package:she_dull/widgets/task.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator.adaptive(
          onRefresh: fetchData,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text("Todo list is empty, bum!"),
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Task(
                  index: "${index + 1}",
                  options: PopupMenuButton(
                    icon: const Icon(Icons.more_horiz),
                    onSelected: (value) {
                      if (value == "edit") {
                        // edit page
                        navigateToEditPage(item);
                      } else if (value == "delete") {
                        // delete
                        deleteById(id);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: "edit",
                          child: Text("Edit"),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Text("Delete"),
                        )
                      ];
                    },
                  ),
                  title: Text(
                    item["title"],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  desc: Text(
                    item['description'],
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 4,
                  ),
                  onTap: () {},
                  onLongPress: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (builder) => Container(
                        // color: Colors.white,
                        child: const Text("data"),
                      ),
                    );
                    Scaffold.of(context);
                  },
                );
              },
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Row(
          children: [
            Text("Add new   "),
            // I WAS TOO LAZY TO USE A SIZEDBOX TO MAKE A SPACE BETWEEN THE 2 WIDGETS
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (builder) => Add(todo: item),
      ),
    );
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateToAddPage() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (builder) => const Add(),
      ),
    );
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> deleteById(id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(
      uri,
      // body: jsonEncode(uri),
    );
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
  }

  Future<void> fetchData() async {
    // setState(() {
    //   isLoading = true;
    // });
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      isLoading = true;
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
