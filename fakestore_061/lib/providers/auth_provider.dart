import 'package:flutter/material.dart';
import '../services/user_api_service.dart';
import '../models/user_model.dart';

enum AppRole { admin, user }

class AuthProvider extends ChangeNotifier {
  final _api = UserApiService();

  bool _isLoggedIn = false;
  AppRole? _role;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  AppRole? get role => _role;
  String? get username => _username;

  bool isLoading = false;
  String? error;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // 🔥 ดึง users ทั้งหมดจาก API
      final List<UserModel> users = await _api.fetchUsers();

      // 🔎 หา user ที่ username/password ตรงกัน
      UserModel? found;
      for (final u in users) {
        if (u.username == username && u.password == password) {
          found = u;
          break;
        }
      }

      if (found == null) {
        error = "Username หรือ Password ไม่ถูกต้อง";
        _isLoggedIn = false;

        isLoading = false; // ✅ สำคัญ
        notifyListeners();
        return;
      }

      // 🎉 login สำเร็จ
      _username = found.username;
      _role = (found.username == "johnd") ? AppRole.admin : AppRole.user;
      _isLoggedIn = true;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _role = null;
    _username = null;
    error = null;
    notifyListeners();
  }
}
