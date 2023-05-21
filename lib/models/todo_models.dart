class TodoModel {
  final String id;
  final String title;
  final String note;
  // Boleh null, lainnya harus ada isinya
  final DateTime? dueDate;
  final bool completed;
  final double latitude;
  final double longitude;

  TodoModel({
    required this.id,
    required this.title,
    this.note = '',
    this.dueDate,
    this.completed = false,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  // Function untuk dapat merubah nilai dari Final
  TodoModel copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? dueDate,
    bool? completed,
    double? latitude,
    double? longitude,
  }) {
    if (dueDate != null) {
      if (dueDate.compareTo(DateTime(0)) == 0) {
        dueDate = null;
      }
    } else {
      // Kalau null
      dueDate = this.dueDate;
    }
    return TodoModel(
      // Kalau null dia akan ngambil title dari yang paling pertama
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: dueDate,
      completed: completed ?? this.completed,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
