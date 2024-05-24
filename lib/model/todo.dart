import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Todo {
  Todo({required this.title, String? id}) : id = id ?? uuid.v4();

  final String title;
  final String id;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      id: json['id'],
    );
  }
}
