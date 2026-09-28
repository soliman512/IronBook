import 'package:flutter/material.dart';

enum UserGymMode { owner, member }

class AuthProvider extends ChangeNotifier {
  UserGymMode? _userGymMode;
  UserGymMode? get getUserGymMode => _userGymMode;
  set setUserGymMode(UserGymMode mode) {
    _userGymMode = mode;
    notifyListeners();
  }
}
