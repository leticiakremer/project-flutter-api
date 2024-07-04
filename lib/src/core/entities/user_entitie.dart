class UserEntity {
  String id;
  String name;
  String email;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserEntity.initial() {
    return UserEntity(
      id: '',
      name: '',
      email: '',
    );
  }

  UserEntity copy({
    String? id,
    String? name,
    String? email,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  UserEntity update({
    String? id,
    String? name,
    String? email,
  }) {
    this.id = id ?? this.id;
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    return this;
  }

  factory UserEntity.fromJson(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}
