import '../models/user_model.dart';
import 'auth_repository.dart';
import '../../services/storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final StorageService _storageService;

  AuthRepositoryImpl(this._storageService);

  @override
  Future<UserModel> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (username == 'admin' && password == 'admin123') {
      const user = UserModel(
        id: '1',
        username: 'admin',
        name: 'Administrator',
        role: UserRole.admin,
        permissions: [
          'view_ticket',
          'create_ticket',
          'edit_ticket',
          'delete_ticket',
          'print_ticket',
          'manage_users',
        ],
      );
      await _storageService.setLoggedIn(true);
      await _storageService.setUserToken('mock_token_123');
      await _storageService.setUserId(user.id);
      await _storageService.setUserName(user.name);
      return user;
    } else if (username == 'user' && password == 'user123') {
      const user = UserModel(
        id: '2',
        username: 'user',
        name: 'Regular User',
        role: UserRole.user,
        permissions: ['view_ticket', 'create_ticket', 'print_ticket'],
      );
      await _storageService.setLoggedIn(true);
      await _storageService.setUserToken('mock_token_456');
      await _storageService.setUserId(user.id);
      await _storageService.setUserName(user.name);
      return user;
    } else if (username == 'viewer' && password == 'viewer123') {
      const user = UserModel(
        id: '3',
        username: 'viewer',
        name: 'Viewer',
        role: UserRole.viewer,
        permissions: ['view_ticket'],
      );
      await _storageService.setLoggedIn(true);
      await _storageService.setUserToken('mock_token_789');
      await _storageService.setUserId(user.id);
      await _storageService.setUserName(user.name);
      return user;
    }

    throw Exception('Invalid username or password');
  }

  @override
  Future<void> logout() async {
    await _storageService.logout();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (!await isLoggedIn()) return null;

    final userId = _storageService.userId;
    final userName = _storageService.userName;

    if (userId == null || userName == null) return null;

    return UserModel(
      id: userId,
      username: userName.toLowerCase(),
      name: userName,
      role: UserRole.user,
      permissions: const ['view_ticket'],
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return _storageService.isLoggedIn;
  }
}
