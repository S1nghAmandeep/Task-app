import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todolist_app/view/new_todo.dart';
import 'package:todolist_app/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() {
    return _TodoListViewState();
  }
}

class _TodoListViewState extends State<TodoListView> {
  List<Todo> todos = [];
  List<Todo> filteredTodos = [];
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
    searchController.addListener(_onSearchChanged);
  }

  void _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List decodedTodos = jsonDecode(todosString);
      setState(() {
        todos = decodedTodos.map((e) => Todo.fromJson(e)).toList();
        filteredTodos = todos;
      });
    }
  }

   void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text;
      filteredTodos = todos
          .where((todo) => todo.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedTodos =
        jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', encodedTodos);
  }

  void saveTodo(Todo todo) {
    setState(() {
      todos.add(todo);
      filteredTodos = todos;
    });
    _saveTodos();
  }

  void removeTodo(Todo todo) {
    final todoIndex = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
      filteredTodos = todos;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Todo deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                todos.insert(todoIndex, todo);
                filteredTodos = todos;
              });
            }),
      ),
    );
    _saveTodos();
  }

  @override
  Widget build(BuildContext context) {
    Widget screenView = const Center(
      child: Text(
        'Nessun todo presente....',
        style: TextStyle(fontSize: 30),
      ),
    );

    if (todos.isNotEmpty) {
      screenView = Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(filteredTodos[index]),
                background: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                ),
                onDismissed: (direction) => removeTodo(filteredTodos[index]),
                child: ListTile(
                  title: Text(filteredTodos[index].title),
                ),
              ),
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => NewTodoView(onAddTodo: saveTodo),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: screenView,
    );
  }
}
