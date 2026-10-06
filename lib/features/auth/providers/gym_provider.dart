import 'package:flutter/material.dart';
import 'package:ironbook/features/auth/models/gym_model.dart';

class GymProvider extends ChangeNotifier {
  GymModel? _gymModel;

  GymModel? get getGym => _gymModel;

  set setGym(GymModel? gym) {
    _gymModel = gym;
    notifyListeners();
  }
}
