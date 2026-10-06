import 'package:flutter/material.dart';
import 'package:ironbook/features/member/models/member_ship_model.dart';

class MembershipProvider extends ChangeNotifier {
  MembershipModel? _membership;

  MembershipModel? get membership => _membership;

  void setMembership(MembershipModel? membership) {
    _membership = membership;
    notifyListeners();
  }

  void clearMembership() {
    _membership = null;
    notifyListeners();
  }

  
}