import 'dart:convert';

class User {
  final String id;
  final String name;
  final String? surname; // Nullable since it's not required
  final String? bio; // Nullable as it's not a required field in Node.js
  final String nick;
  final String? email;
  final String? password;
  final String role;
  final String image;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    this.surname,
    this.bio,
    required this.nick,
    this.email,
    this.password,
    this.role = 'role_user', // Default value
    this.image = 'default.png', // Default value
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now(); // Default value

  factory User.fromMap(Map<String, dynamic> userMap) => User(
    id: userMap['id'],
    name: userMap['name'],
    surname: userMap['surname'],
    bio: userMap['bio'],
    nick: userMap['nick'],
    email: userMap['email'],
    password: userMap['password'],
    role: userMap['role'] ?? 'role_user',
    image: userMap['image'] ?? 'default.png',
    createdAt: userMap['created_at'] != null
      ? DateTime.parse(userMap['created_at'])
      : null,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'surname': surname,
    'bio': bio,
    'nick': nick,
    'email': email,
    'password': password,
    'role': role,
    'image': image,
    'created_at': createdAt.toIso8601String(),
  };

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
}
