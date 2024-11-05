import 'package:flutter/material.dart';
import 'package:fundora/src/model/user.dart';
import 'package:fundora/src/services/userservices.dart';
import 'package:logging/logging.dart';

class UserViewModel extends ChangeNotifier {
  final Userservices _userService;
  final Logger _logger = Logger("UserViewModel");
  User? _userModel;
  bool _isLoading = false;

  UserViewModel(this._userService) {
    checkCurrentUser();
  }
  User? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String get id => _userModel?.id ?? '';
  String get name => _userModel?.name ?? 'Guest';
  String get email => _userModel?.email ?? 'No email';
  bool get isLoggedIn => _userModel != null;

  Future<void> checkCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUser = _userService.getCurrentUser();
      if (currentUser != null) {
        final userData = await _userService.getUserData(currentUser.uid);
        if (userData != null) {
          _userModel = User.fromJson(userData);
          _logger.info("Current user loaded: ${_userModel?.email}");
        }
      }
    } catch (e) {
      _logger.severe("Error checking current user: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> registerUser(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      var firebaseUser =
          await _userService.registerWithEmailAndPassword(email, password);
      if (firebaseUser != null) {
        _userModel = User(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          name: name,
        );
        await _userService.saveUserData(firebaseUser.uid, _userModel!.toJson());
        _logger.info("User registered: ${_userModel!.toJson()}");
        notifyListeners();
        return _userModel;
      }
    } catch (e) {
      _logger.severe("Registration error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<User?> loginUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      var firebaseUser =
          await _userService.loginWithEmailAndPassword(email, password);
      if (firebaseUser != null) {
        var userData = await _userService.getUserData(firebaseUser.uid);
        if (userData != null) {
          _userModel = User.fromJson(userData);
          _logger.info("User logged in: ${_userModel!.toJson()}");
          notifyListeners();
          return _userModel;
        } else {
          _logger.warning("No user data found for UID: ${firebaseUser.uid}");
        }
      }
    } catch (e) {
      _logger.severe("Login error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> updateUser(Map<String, dynamic> newUserData) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _userService.updateUserData(_userModel!.id, newUserData);
      _userModel = User(
        id: _userModel!.id,
        name: newUserData['name'] ?? _userModel!.name,
        email: newUserData['email'] ?? _userModel!.email,
      );
      _logger.info("User updated: ${_userModel!.toJson()}");
      notifyListeners();
    } catch (error) {
      _logger.severe("Error updating user data: $error");
      throw Exception("Error updating user data: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _userService.updatePassword(newPassword);
      _logger.info("Password updated successfully");
    } catch (error) {
      _logger.severe("Error updating password: $error");
      throw Exception("Error updating password: $error");
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _userService.signOut();
      _userModel = null;
      notifyListeners();
    } catch (e) {
      _logger.severe("Logout error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
