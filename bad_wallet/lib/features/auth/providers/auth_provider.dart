import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _phoneKey = 'user_phone';

  String? _phone;
  bool _isLoading = true;

  String? get phone => _phone;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _phone != null;

  Future<void> loadPhone() async {
    _phone = await _storage.read(key: _phoneKey);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> savePhone(String phone) async {
    await _storage.write(key: _phoneKey, value: phone);
    _phone = phone;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: _phoneKey);
    _phone = null;
    notifyListeners();
  }
}
