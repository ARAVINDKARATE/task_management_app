class Task {
  String name;
  DateTime? dueDate;
  String priority;
  bool isCompleted;

  Task({
    required this.name,
    this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      priority: json['priority'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  Task copyWith({String? name, DateTime? dueDate, String? priority}) {
    return Task(
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}
