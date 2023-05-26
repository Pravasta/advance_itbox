import 'package:flutter/material.dart';
import 'package:todos/pages/screen/all_todo_screen.dart';
import 'package:todos/pages/screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // untuk pindah bottom navigationbar
  int selectedIndex = 0;
  static const List<Widget> _widget = [
    AllTodoScreen(),
    ProfileScreen(),
  ];

  // Untuk menentukan selected index ke berapa
  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // untuk membuat focus layar ketika klik layar habis isi text keyboard menjadi turun
    return Scaffold(
      body: _widget[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'All Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTap,
      ),
    );
  }
}
