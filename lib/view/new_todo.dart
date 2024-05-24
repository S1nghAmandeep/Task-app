import 'package:flutter/material.dart';
import 'package:todolist_app/model/todo.dart';

class NewTodoView extends StatefulWidget {
  const NewTodoView({required this.onAddTodo, super.key});

  final void Function(Todo todo) onAddTodo;

  @override
  State<NewTodoView> createState() => _NewTodoViewState();
}

class _NewTodoViewState extends State<NewTodoView> {
  final newTodoController = TextEditingController();

  @override
  void dispose() {
    newTodoController.dispose();
    super.dispose();
  }

  void saveTodo() {
      widget.onAddTodo(Todo(title: newTodoController.text));
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: newTodoController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: saveTodo,
                  child: const Text('Save Todo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
