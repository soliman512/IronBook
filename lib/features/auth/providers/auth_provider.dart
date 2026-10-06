import 'package:flutter/material.dart';
import 'package:ironbook/features/auth/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserRole? _userRole;
  UserModel? _user;

  UserModel? get getUser => _user;
  UserRole? get getUserRole => _userRole;

  set setUserRole(UserRole mode) {
    _userRole = mode;
    notifyListeners();
  }

  set setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
