import 'package:flutter/widgets.dart';

import '../models/user_model.dart';

class CurrentUser extends ChangeNotifier {
  UserModel _currentUser = UserModel.empty();

  UserModel get user => _currentUser;

  String _userToken = '';

  String get token => _userToken;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setToken(String token) {
    _userToken = token;
    notifyListeners();
  }

  void logoutUser() {
    _currentUser = UserModel.empty();
    _userToken = '';
    notifyListeners();
  }
}
