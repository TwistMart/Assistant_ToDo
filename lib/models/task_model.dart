class Task {
  final int? id;
  final int userId;
  final int? assignedToId;
  final String title;
  final String? description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? assignedToName; // To display assistant's name

  Task({
    this.id,
    required this.userId,
    this.assignedToId,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignedToName,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'],
      assignedToId: json['assigned_to_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      assignedToName: json['assigned_to'] != null ? json['assigned_to']['name'] : null, // Assuming Laravel returns assigned_to relationship
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'assigned_to_id': assignedToId,
      'title': title,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Task copyWith({
    int? id,
    int? userId,
    int? assignedToId,
    String? title,
    String? description,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedToName,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      assignedToId: assignedToId ?? this.assignedToId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedToName: assignedToName ?? this.assignedToName,
    );
  }
}

class Assistant {
  final int id;
  final String name;
  final String email;

  Assistant({required this.id, required this.name, required this.email});

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}