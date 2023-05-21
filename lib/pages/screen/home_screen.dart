import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todos/pages/widget/new_todo.dart';

import '../widget/todo_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // untuk membuat focus layar ketika klik layar habis isi text keyboard menjadi turun
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Advance ITBOX'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
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
