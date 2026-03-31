import '../../data/models/user_model.dart';

class PermissionService {
  final UserModel? _currentUser;

  PermissionService(this._currentUser);

  bool get isLoggedIn => _currentUser != null;

  String? get userId => _currentUser?.id;

  String? get userName => _currentUser?.name;

  UserRole? get userRole => _currentUser?.role;

  bool get isAdmin => _currentUser?.role == UserRole.admin;

  bool hasPermission(String permission) {
    return _currentUser?.permissions.contains(permission) ?? false;
  }

  bool hasAnyPermission(List<String> permissions) {
    return permissions.any((p) => hasPermission(p));
  }

  bool hasAllPermissions(List<String> permissions) {
    return permissions.every((p) => hasPermission(p));
  }

  static const String viewTicket = 'view_ticket';
  static const String createTicket = 'create_ticket';
  static const String editTicket = 'edit_ticket';
  static const String deleteTicket = 'delete_ticket';
  static const String printTicket = 'print_ticket';
  static const String manageUsers = 'manage_users';
}
