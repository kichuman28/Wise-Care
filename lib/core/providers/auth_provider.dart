import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((user) async {
      _user = user;
      if (user != null) {
        debugPrint('Auth state changed - user signed in');
        try {
          await _saveUserToFirestore(user);
        } catch (e) {
          debugPrint('Error saving user data on auth state change: $e');
        }
      } else {
        debugPrint('Auth state changed - user signed out');
      }
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  String get userName => _user?.displayName ?? 'Guest';
  String get userEmail => _user?.email ?? '';
  String? get userPhotoUrl => _user?.photoURL;
  String get uid => _user?.uid ?? '';

  Future<void> _saveUserToFirestore(User user) async {
    try {
      debugPrint('Attempting to save user to Firestore...');
      debugPrint('User ID: ${user.uid}');
      debugPrint('User Email: ${user.email}');

      final userRef = _firestore.collection('users').doc(user.uid);
      debugPrint('Created reference to users collection');

      // Check if user document already exists
      debugPrint('Checking if user document exists...');
      final userDoc = await userRef.get();
      debugPrint('Document exists: ${userDoc.exists}');

      if (!userDoc.exists) {
        debugPrint('Creating new user document...');
        // Create new user document if it doesn't exist
        final userData = {
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'provider': 'google',
        };
        debugPrint('User data to save: $userData');
        await userRef.set(userData);
        debugPrint('Successfully created new user document');
      } else {
        debugPrint('Updating existing user document...');
        // Update last login time if user already exists
        final updateData = {
          'lastLoginAt': FieldValue.serverTimestamp(),
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
        };
        debugPrint('Update data: $updateData');
        await userRef.update(updateData);
        debugPrint('Successfully updated user document');
      }
    } catch (e, stackTrace) {
      debugPrint('Error saving user to Firestore: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint('Starting Google Sign In process...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('Google Sign In was cancelled by user');
        return null;
      }
      debugPrint('Google Sign In successful, getting auth credentials...');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('Getting Firebase UserCredential...');
      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint('Firebase UserCredential obtained successfully');

      // Save user data to Firestore after successful sign in
      if (userCredential.user != null) {
        debugPrint('Attempting to save user data to Firestore from signInWithGoogle...');
        await _saveUserToFirestore(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }
}
