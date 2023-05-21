import 'package:flutter/material.dart';
import 'package:todos/function.dart';
import 'package:todos/models/todo_models.dart';

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({super.key, required this.todoModel});
  final TodoModel todoModel;

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  TodoModel _todoModel = TodoModel(id: '', title: '');
  final TextEditingController _todoTitleController = TextEditingController();
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    // memberi nilai todo model dari page todo_list
    _todoModel = widget.todoModel;
    // Set nilai todoController dengan nilai _todoModel
    _todoTitleController.text = _todoModel.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo Detail'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Apa yang mau kamu lakukan ?'),
                const SizedBox(height: 10),
                TextField(
                  controller: _todoTitleController,
                  decoration: const InputDecoration(
                    hintText: 'Saya mau ....',
                  ),
                  // Pada saat nilai berubah kita mengset nilai kedalam objek Todo Model kita
                  onChanged: (value) {
                    // Nah yang mau diubah yang mana
                    _todoModel = _todoModel.copyWith(
                      title: value,
                    );
                  },
                ),
                const SizedBox(height: 25),
                const Text('Tanggal waktu penyelesaian'),
                const SizedBox(height: 10),
                if (_todoModel.dueDate != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatDateTime(_todoModel.dueDate),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                // Belum hilang jika belum diubah di bagian todo_model
                                _todoModel =
                                    _todoModel.copyWith(dueDate: DateTime(0));
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_todoModel.dueDate == null)
                  Row(
                    children: [
                      dueDateButton('Hari ini', value: _today),
                      dueDateButton(
                        'Besok',
                        value: _today.add(
                          const Duration(days: 1),
                        ),
                      ),
                    ],
                  ),
                if (_todoModel.dueDate == null)
                  Row(
                    children: [
                      dueDateButton(
                        'Minggu Depan',
                        value: _today.add(
                          // Misal kamis itu kan = index ke - 3
                          /* 
                        0 => senin
                        jadi 3 - 7 = -4 => di abs = 4 
                        Jadi kalau sekarang 3 maka ditambah 4 akan menjadi 7 jadi senin
                        */
                          Duration(days: (_today.weekday - 7).abs() + 1),
                        ),
                      ),
                      dueDateButton(
                        'Custom',
                        onPressed: () async {
                          // Pilih tanggal sendiri dari calender
                          // nilai bisa null jika tidak jadi klik
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _today,
                            firstDate: _today,
                            lastDate: DateTime(
                              _today.year + 100,
                            ),
                          );

                          if (pickedDate != null) {
                            // Jika tidak null baru bisa kita set tnggl tersebut
                            setState(
                              () {
                                _todoModel =
                                    _todoModel.copyWith(dueDate: pickedDate);
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                // CATATAN
                const SizedBox(height: 25),
                const Text('Catatan'),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Ketuk untuk tambahkan catatan...',
                    ),
                  ),
                ),
                // LOKASI
                const SizedBox(height: 25),
                const Text('Lokasi'),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Ketuk untuk tambahkan Lokasi',
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Button
                ElevatedButton(
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      Text('Simpan'),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      Text('Selesai'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dueDateButton(String text, {DateTime? value, Function()? onPressed}) {
    return Expanded(
      child: ElevatedButton.icon(
        // Kalau null maka akan ke set state, klau tidak ke open kalender
        onPressed: onPressed ??
            () {
              setState(() {
                _todoModel = _todoModel.copyWith(dueDate: value);
              });
            },
        icon: const Icon(Icons.alarm_add),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
