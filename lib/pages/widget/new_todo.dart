import 'package:flutter/material.dart';
import 'package:todos/services/database_service.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({super.key});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  String _todoTitle = '';
  final _todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _todoTitleController,
              onChanged: (value) {
                setState(() {
                  _todoTitle = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Saya mau...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  // borderside untuk ketebalan
                  borderSide: const BorderSide(width: 0.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          ElevatedButton(
            // jika di kotak todo TextField kosong, maka tidak akan melakukan apa apa
            onPressed: _todoTitle.isEmpty
                ? null
                : () {
                    DatabaseService().addNewTodo(_todoTitle);
                    _todoTitleController.clear();
                  },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
