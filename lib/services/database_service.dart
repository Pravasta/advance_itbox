import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todos/models/todo_models.dart';
import 'package:todos/models/users_model.dart';

class DatabaseService {
  // dapatkan uid untk pembeda user
  String uid = '';

  // Dijalankan pertama kali ketika database service ini dibuat
  DatabaseService() {
    if (FirebaseAuth.instance.currentUser != null) {
      uid = FirebaseAuth.instance.currentUser!.uid;
    }
  }

  // Jembatan FirebaseFireStore
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('todos');
  final CollectionReference _dataUserReferance =
      FirebaseFirestore.instance.collection('users');

  // Ini untuk mengubah snapshot kedalam model todos
  List<TodoModel> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return TodoModel(
        id: e.id,
        title: data['title'] ?? "",
        note: data['note'] ?? "",
        completed: data['completed'] ?? false,
        dueDate:
            data['due_date'] == null ? null : DateTime.parse(data['due_date']),
        latitude: data['location'] == null ? 0.0 : data['location'].latitude,
        longitude: data['location'] == null ? 0.0 : data['location'].longitude,
      );
    }).toList();
  }

  // Fungsi untuk mereturn sebuah stream list Todo
  // tambahkan order untuk ngurutin
  Stream<List<TodoModel>> get todos {
    // Krena didalam snapshot berisi sebuah map, maka dapat di .Map
    return _collectionReference
        .where('uid', isEqualTo: uid)
        .orderBy('completed')
        .orderBy('due_date')
        .snapshots()
        // dimap lagi karena di docs ini berisi banyak data
        .map(_todoListFromSnapshot);
  }

  // Mengubah snapshot ke model user data
  UserModel _dataUserFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      username: data['username'] ?? "",
      email: data['email'] ?? "",
      phone: data['phone'] ?? "",
      // type null not subtype of type string karena belum memberi nilai default image url
      imageUrl: data['imageUrl'] ?? "",
    );
  }

  Stream<UserModel> get dataUser {
    // lebih spesifik karena disini documentsnapshot
    return _dataUserReferance.doc(uid).snapshots().map(
          _dataUserFromSnapshot,
        );
  }

  Future addNewTodo(String title) {
    return _collectionReference.add({
      'title': title,
      // Biar order by dari competed muncul
      'completed': false,
      'uid': uid,
      'due_date': null,
    });
  }

  Future updateTodo(TodoModel todoModel) {
    return _collectionReference.doc(todoModel.id).update({
      'title': todoModel.title,
      'note': todoModel.note,
      'location': GeoPoint(todoModel.latitude, todoModel.longitude),
      'due_date': todoModel.dueDate == null
          ? null
          : todoModel.dueDate!.toIso8601String(),
      'completed': todoModel.completed,
      // Kapan terakhir kali di update
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // Delete Todo
  Future deleteTodo(String docId) {
    return _collectionReference.doc(docId).delete();
  }

  // Fungsi Selesai / COmpleted
  Future toogleComplete(TodoModel todoModel) {
    return _collectionReference.doc(todoModel.id).update({
      // diberi ! untuk jika true jadi false, begitupun kebalikannya
      'completed': !todoModel.completed,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // Edit username dan phone
  Future updateUserName(String username) {
    return _dataUserReferance.doc(uid).update({
      'username': username,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // upload foto profilt
  Future uploadUserImage(File file) async {
    // Folder user_data dan masuk ke file uid kita
    final ref =
        FirebaseStorage.instance.ref().child('user_data').child('$uid.jpg');
    await ref.putFile(file);

    // Karena sudah ada didatabase
    // Tampung url yang kita download
    final url = await ref.getDownloadURL();

    // Setelah kita download kita update di firestore
    await _dataUserReferance.doc(uid).update({
      'imageUrl': url,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
