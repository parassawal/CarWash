import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _googleInitialized = false;
  String _cachedPhone = '';

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  String get userId => _auth.currentUser?.uid ?? '';
  String get userName => _auth.currentUser?.displayName ?? 'User';
  String get userEmail => _auth.currentUser?.email ?? '';
  String get userPhone => _cachedPhone;
  String get userInitials {
    final name = userName;
    if (name.isEmpty || name == 'User') return 'U';
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email/password
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    String phone = '',
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user?.updateDisplayName(name);
      await result.user?.reload();
      _cachedPhone = phone;
      await _saveUserProfile(result.user!.uid, name: name, email: email, phone: phone);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return e.toString();
    }
  }

  // Sign in with email/password
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Load cached phone from profile
      await _loadUserPhone(result.user!.uid);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return e.toString();
    }
  }

  // Google Sign-In (v7.x API)
  Future<String?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;

      // Initialize once
      if (!_googleInitialized) {
        await googleSignIn.initialize(
          serverClientId:
              '527356236873-qle515uud4shp0ocvannids1d67maglc.apps.googleusercontent.com',
        );
        _googleInitialized = true;
      }

      // Authenticate (shows Google sign-in UI)
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // Get idToken for Firebase credential
      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        return 'Failed to get authentication token';
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      final user = result.user!;
      await _saveUserProfile(user.uid, name: user.displayName ?? '', email: user.email ?? '', phone: user.phoneNumber ?? '');
      await _loadUserPhone(user.uid);
      notifyListeners();
      return null;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return 'Sign-in cancelled';
      }
      return 'Google sign-in failed: ${e.description ?? e.code.name}';
    } catch (e) {
      return 'Google sign-in failed. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      if (_googleInitialized) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (_) {}
    _cachedPhone = '';
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> _saveUserProfile(String uid, {required String name, required String email, required String phone}) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _loadUserPhone(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        _cachedPhone = doc.data()?['phone'] ?? '';
      }
    } catch (_) {}
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
