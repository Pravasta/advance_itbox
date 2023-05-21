import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todos/firebase_options.dart';
import 'package:todos/pages/screen/auth_screen.dart';
import 'package:todos/pages/screen/home_screen.dart';

void main() async {
  // Akan error jiga tidak aada ini
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Konsep login jika menggunakan statefull, kalau ada provider , cubit, bloc, getX, riverpod, dll bisa berbeda
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const AuthScreen();
          } else {
            return const HomeScreen();
          }
        },
      ),
    );
  }
}
