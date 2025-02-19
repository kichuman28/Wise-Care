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
          await _ensureDoctorsExist();
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

  Future<void> _ensureDoctorsExist() async {
    try {
      final doctorsRef = _firestore.collection('doctors');
      final doctorsSnapshot = await doctorsRef.get();

      if (doctorsSnapshot.docs.isEmpty) {
        debugPrint('No doctors found, adding static data...');

        final List<Map<String, dynamic>> staticDoctors = [
          {
            'name': 'Dr. Sarah Johnson',
            'mail': 'sarah@wisecare.in',
            'specialization': 'Cardiologist',
            'imageUrl': 'https://picsum.photos/200',
            'about': 'Experienced cardiologist with over 15 years of practice in treating heart conditions.',
            'rating': 4.8,
            'experience': 15,
            'patientsServed': 10000,
            'availableDays': ['Monday', 'Wednesday', 'Friday'],
            'availableTimeSlots': {
              'Monday': ['09:00', '10:00', '11:00', '14:00', '15:00'],
              'Wednesday': ['10:00', '11:00', '14:00', '15:00', '16:00'],
              'Friday': ['09:00', '10:00', '11:00', '14:00', '15:00'],
            },
            'consultationFee': 150.0,
            'isAvailable': true,
          },
          {
            'name': 'Dr. Michael Chen',
            'mail': 'michael@wisecare.in',
            'specialization': 'Neurologist',
            'imageUrl': 'https://picsum.photos/200',
            'about': 'Specialized in treating neurological disorders with a focus on innovative treatments.',
            'rating': 4.9,
            'experience': 12,
            'patientsServed': 8000,
            'availableDays': ['Tuesday', 'Thursday', 'Saturday'],
            'availableTimeSlots': {
              'Tuesday': ['09:00', '10:00', '11:00', '14:00', '15:00'],
              'Thursday': ['10:00', '11:00', '14:00', '15:00', '16:00'],
              'Saturday': ['09:00', '10:00', '11:00'],
            },
            'consultationFee': 180.0,
            'isAvailable': true,
          },
          {
            'name': 'Dr. Emily Rodriguez',
            'mail': 'emily@wisecare.in',
            'specialization': 'Pediatrician',
            'imageUrl': 'https://picsum.photos/200',
            'about': 'Dedicated pediatrician with a gentle approach to child healthcare.',
            'rating': 4.7,
            'experience': 8,
            'patientsServed': 6000,
            'availableDays': ['Monday', 'Tuesday', 'Thursday', 'Friday'],
            'availableTimeSlots': {
              'Monday': ['09:00', '10:00', '11:00', '14:00', '15:00'],
              'Tuesday': ['10:00', '11:00', '14:00', '15:00'],
              'Thursday': ['09:00', '10:00', '11:00', '14:00'],
              'Friday': ['10:00', '11:00', '14:00', '15:00'],
            },
            'consultationFee': 120.0,
            'isAvailable': true,
          },
        ];

        for (final doctorData in staticDoctors) {
          await doctorsRef.add(doctorData);
        }

        debugPrint('Added static doctor data successfully');
      }
    } catch (e) {
      debugPrint('Error ensuring doctors exist: $e');
    }
  }
}
