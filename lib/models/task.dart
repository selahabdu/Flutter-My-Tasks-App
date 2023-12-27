class Task {
  String content;
  DateTime timeStamp;
  bool completed;

  Task(
      {required this.completed,
      required this.timeStamp,
      required this.content});

  factory Task.fromMap(Map task) {
    return Task(
      completed: task['completed'],
      timeStamp: task['timeStamp'],
      content: task['content'],
    );
  }

  Map toMap() {
    return {
      'content': content,
      'timeStamp': timeStamp,
      'completed': completed,
    };
  }
}
