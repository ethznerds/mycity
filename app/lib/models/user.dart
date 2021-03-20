import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  static final UserModel _userModel = UserModel._internal();

  bool _is_logged_in = false;
  String _firstName = "";
  String _lastName = "";

  factory UserModel() {
    return _userModel;
  }

  void setUser(String firstName, String lastName) {
    this._firstName = firstName;
    this._lastName = lastName;
    this._is_logged_in = true;

    notifyListeners();
  }

  bool login(String username, String password) {
    //TODO
    return true;
  }

  bool loggedIn() {
    return _is_logged_in;
  }

  void logout() {
    this._firstName = "";
    this._lastName = "";
    this._is_logged_in = false;

    notifyListeners();
  }

  UserModel._internal();
}
