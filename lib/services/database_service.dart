import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todos/models/todo_models.dart';

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
  Stream<List<TodoModel>> get todos {
    // Krena didalam snapshot berisi sebuah map, maka dapat di .Map
    return _collectionReference
        .snapshots()
        // dimap lagi karena di docs ini berisi banyak data
        .map(_todoListFromSnapshot);
  }

  Future addNewTodo(String title) {
    return _collectionReference.add({
      'title': title,
      'uid': uid,
    });
  }
}
