import 'package:flutter/material.dart';
import 'package:todos/function.dart';
import 'package:todos/models/todo_models.dart';
import 'package:todos/pages/screen/todo_detail_screen.dart';
import 'package:todos/services/database_service.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TodoModel>>(
      stream: DatabaseService().todos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Jika ada error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }
        if (snapshot.hasData) {
          final todoList = snapshot.data;
          return ListView.builder(
            itemCount: todoList!.length,
            itemBuilder: (context, index) {
              return Card(
                color: todoList[index].completed ? Colors.grey : Colors.white,
                child: ListTile(
                  onTap: todoList[index].completed
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoDetailScreen(
                                todoModel: todoList[index],
                              ),
                            ),
                          ),
                  leading: IconButton(
                    onPressed: () {
                      DatabaseService().toogleComplete(todoList[index]);
                    },
                    icon: todoList[index].completed
                        ? const Icon(Icons.check_outlined)
                        : const Icon(
                            Icons.circle_outlined,
                          ),
                  ),
                  title: Text(todoList[index].title),
                  subtitle: todoList[index].dueDate == null
                      ? null
                      : Text(
                          formatDateTime(todoList[index].dueDate),
                        ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              'Tidak ada data yang ditampilkan',
            ),
          );
        }
      },
    );
  }
}
