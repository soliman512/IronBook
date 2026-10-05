import 'package:flutter/material.dart';
import 'package:ironbook/features/auth/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserGymMode? _userGymMode;
  UserModel? _user;


  UserModel? get getUser => _user;
  UserGymMode? get getUserGymMode => _userGymMode;
  
  set setUserGymMode(UserGymMode mode) {
    _userGymMode = mode;
    notifyListeners();
  }
  
  set setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
