import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

//TODO agregar storage de firebase para almacenar avatares del usuario
class Userservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger("Userservices");

  User? getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _logger.info("Current user retrieved: ${user.email}");
      } else {
        _logger.info("No current user found");
      }
      return user;
    } catch (error) {
      _logger.severe("Error getting current user", error);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _logger.info("User signed out successfully");
    } catch (error) {
      _logger.severe("Error signing out", error);
      throw Exception("Failed to sign out: $error");
    }
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.info("User registered with UID: ${userCredential.user!.uid}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed";
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
      }
      _logger.severe("Registration error: $errorMessage", e);
      throw Exception(errorMessage);
    } catch (error) {
      _logger.severe("Unexpected registration error", error);
      throw Exception("Registration failed: $error");
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.info("User logged in with UID: ${userCredential.user!.uid}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
      }
      _logger.severe("Login error: $errorMessage", e);
      throw Exception(errorMessage);
    } catch (error) {
      _logger.severe("Unexpected login error", error);
      throw Exception("Login failed: $error");
    }
  }

  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .set(userData, SetOptions(merge: true));
      _logger.info("User data saved successfully for UID: $uid");
    } catch (error) {
      _logger.severe("Error saving user data", error);
      throw Exception("Failed to save user data: $error");
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        _logger.info("User data retrieved successfully for UID: $uid");
        return doc.data() as Map<String, dynamic>;
      } else {
        _logger.warning("No user data found for UID: $uid");
        return null;
      }
    } catch (error) {
      _logger.severe("Error retrieving user data", error);
      throw Exception("Failed to get user data: $error");
    }
  }
}
