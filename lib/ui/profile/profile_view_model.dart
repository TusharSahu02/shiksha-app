import 'package:flutter/material.dart';
import '../../data/models/user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  final phoneController = TextEditingController(text: '+91 98765 43210');
  final verifyPhoneController = TextEditingController(text: '+91 98765 43210');

  UserProfile _profile = const UserProfile();
  UserProfile get profile => _profile;

  void saveChanges() {
    _profile = _profile.copyWith(phone: phoneController.text);
    notifyListeners();
    // TODO: Persist profile changes
  }

  void sendOtp() {
    // TODO: Send OTP via email
  }

  @override
  void dispose() {
    phoneController.dispose();
    verifyPhoneController.dispose();
    super.dispose();
  }
}
