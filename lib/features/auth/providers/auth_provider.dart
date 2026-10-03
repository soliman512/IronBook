import 'package:flutter/material.dart';
import 'package:ironbook/features/auth/models/user_model.dart';


class AuthProvider extends ChangeNotifier {
  UserGymMode? _userGymMode;
  UserGymMode? get getUserGymMode => _userGymMode;
  set setUserGymMode(UserGymMode mode) {
    _userGymMode = mode;
    notifyListeners();
  }
}
