import 'package:flutter/material.dart';
import 'package:todos/function.dart';
import 'package:todos/models/place_location_models.dart';
import 'package:todos/models/todo_models.dart';
import 'package:todos/pages/widget/maps_widget.dart';
import 'package:todos/services/database_service.dart';

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

  void setLocation(PlaceLocation placeLocation) {
    setState(() {
      _todoModel = _todoModel.copyWith(
          latitude: placeLocation.latitude, longitude: placeLocation.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo Detail'),
          actions: [
            IconButton(
              onPressed: () async {
                // Kenapa diberi ? karena jika tidak tekan tombol Yes atau No biar tidak error
                bool? isDelete = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Hapus ToDo ?'),
                      content: const Text(
                          'Apakah kamu yakin untuk menghapus ToDo ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Ya'),
                        ),
                      ],
                    );
                  },
                );
                if (isDelete != null && isDelete) {
                  DatabaseService().deleteTodo(_todoModel.id);
                  if (!mounted) return;
                  Navigator.pop(context);
                }
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
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
                GestureDetector(
                  onTap: () async {
                    // Ada kemungkinan null jika tidak jadi mengisi note
                    String? note = await showDialog(
                      context: context,
                      builder: (context) {
                        String tempNote = _todoModel.note;
                        return Dialog(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Catatan',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                // Butuh initial value
                                TextFormField(
                                  maxLines: 6,
                                  initialValue: tempNote,
                                  onChanged: (value) {
                                    tempNote = value;
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, tempNote);
                                  },
                                  child: const Text('Simpan'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    // belum kelihatan hasilnya jika belum menambahkan widget
                    if (note != null) {
                      setState(() {
                        _todoModel = _todoModel.copyWith(note: note);
                      });
                    }
                  },
                  child: _todoModel.note.isEmpty
                      ? Container(
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
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: Text(
                            _todoModel.note,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                ),
                // LOKASI
                const SizedBox(height: 25),
                const Text('Lokasi'),
                const SizedBox(height: 10),
                MapsWidget(
                  placeLocation: PlaceLocation(
                    latitude: _todoModel.latitude,
                    longitude: _todoModel.longitude,
                  ),
                  setLocationFn: setLocation,
                ),
                const SizedBox(height: 25),
                // Button
                ElevatedButton(
                  onPressed: () {
                    DatabaseService().updateTodo(_todoModel);
                    Navigator.pop(context);
                  },
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
                  onPressed: () {
                    DatabaseService().toogleComplete(_todoModel);
                    Navigator.pop(context);
                  },
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
