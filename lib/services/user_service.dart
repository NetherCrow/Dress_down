import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 Register a new user and store in Firestore
  static Future<String?> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int age,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'email': email,
        'createdAt': DateTime.now(),
      });

      return null; // ✅ Success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') return 'Invalid email address';
      if (e.code == 'email-already-in-use') return 'Email already in use';
      if (e.code == 'weak-password') return 'Password is too weak';
      return 'Error: ${e.message}';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  // ✅ Save login preference (Remember Me)
  static Future<void> saveLoginState(String email, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', rememberMe);
    await prefs.setString('rememberedEmail', email);
  }

  // ✅ Load saved login state
  static Future<Map<String, dynamic>> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    final email = prefs.getString('rememberedEmail') ?? '';
    return {
      'rememberMe': rememberMe,
      'email': email,
    };
  }

  // ✅ Clear saved login state (use on logout)
  static Future<void> clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('rememberMe');
    await prefs.remove('rememberedEmail');
  }

  // ✅ Optional: Login helper (wraps signIn)
  static Future<String?> signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'User not found';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid email':
          return 'Invalid email address';
        default:
          return 'Error: ${e.message}';
      }
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }
}

