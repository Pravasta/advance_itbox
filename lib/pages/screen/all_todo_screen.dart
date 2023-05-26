import 'package:flutter/material.dart';
import 'package:todos/pages/widget/new_todo.dart';
import 'package:todos/pages/widget/todo_list.dart';

class AllTodoScreen extends StatelessWidget {
  const AllTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Advance ITBOX ToDo List'),
          centerTitle: true,
        ),
        body: const Column(
          children: [
            Expanded(
              child: TodoList(),
            ),
            // Dipindah ke widget lain agar tidak memerlukan banyaj memori karena setState
            NewTodo(),
          ],
        ),
      ),
    );
  }
}
