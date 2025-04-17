class Device {
  final String id;
  final String name;
  final String type;
  String status;
  final String location;
  final DateTime createdAt;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.location,
    required this.createdAt,
  });

  Device copyWith({
    String? id,
    String? name,
    String? type,
    String? status,
    String? location,
    DateTime? createdAt,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      location: json['location'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
} 