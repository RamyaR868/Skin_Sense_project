import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Sign Up Logic
  Future<User?> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Create a user profile in Firestore
      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': DateTime.now(),
        });
      }
      return user;
    } catch (e) {
      print("Error in Sign Up: $e");
      return null;
    }
  }

  // 2. Login Logic
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Error in Login: $e");
      return null;
    }
  }

  // 3. Save Scan Result
  Future<void> saveScanResult(String label, double confidence) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).collection('scans').add({
        'label': label,
        'confidence': confidence,
        'timestamp': DateTime.now(),
      });
    }
  }
}
