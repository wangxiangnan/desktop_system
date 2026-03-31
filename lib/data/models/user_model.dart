import 'package:equatable/equatable.dart';

enum UserRole { admin, user, viewer }

class UserModel extends Equatable {
  final String id;
  final String username;
  final String name;
  final UserRole role;
  final List<String> permissions;

  const UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    required this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.user,
      ),
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role.name,
      'permissions': permissions,
    };
  }

  @override
  List<Object?> get props => [id, username, name, role, permissions];
}
