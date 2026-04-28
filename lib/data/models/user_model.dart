import 'package:desktop_system/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String username;
  final String name;
  final int deptId;
  final String deptName;

  const UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.deptId,
    required this.deptName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      deptId: json['deptId'] as int? ?? 0,
      deptName: json['deptName'] as String? ?? '',
    );
  }

  User toEntity({required UserRole role, required List<String> permissions}) {
    return User(
      id: id,
      username: username,
      name: name,
      deptId: deptId,
      deptName: deptName,
      role: role,
      permissions: permissions,
    );
  }
}
