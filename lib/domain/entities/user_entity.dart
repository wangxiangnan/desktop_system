import 'package:equatable/equatable.dart';

/// User role enumeration
enum UserRole { admin, user, viewer }

/// Domain entity for User
class User extends Equatable {
  final String id;
  final String username;
  final String name;
  final UserRole role;
  final List<String> permissions;

  const User({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    required this.permissions,
  });

  @override
  List<Object?> get props => [id, username, name, role, permissions];
}
