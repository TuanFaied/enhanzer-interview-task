// task_model.dart
class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;

  Task({this.id, required this.title, this.isCompleted = false, this.description = ''});

  // Convert a Task object into a Map object for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
      'description': description,
    };
  }

  // Create a Task object from a Map object.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
