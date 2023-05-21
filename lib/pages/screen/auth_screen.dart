import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todos/pages/widget/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void submitAuthForm(
      String email, String userName, String password, bool isLogin) async {
    // Jika is login => sudah login
    try {
      // Unduk mendapatkan ID user
      UserCredential userCredential;
      if (isLogin) {
        // fungsi login
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // register
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Simpan ke cloud Firestore - sesuai UID nya
        await _firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'username': userName,
            'email': email,
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      // Jika ada error
      var message = e.message ?? 'Mohon periksa data anda kembali';
      ScaffoldMessenger.of(context).clearSnackBars();
      // Tujuannya biar tidak nunggu snackbar muncul yang sesuai waktu itu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                const Text(
                  'Todo',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: AuthForm(
                    submitAuthFormFn: submitAuthForm,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
