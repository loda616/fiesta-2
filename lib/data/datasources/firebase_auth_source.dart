import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';



class FirebaseAuthSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthSource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<firebase_auth.UserCredential> signIn(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  Future<firebase_auth.UserCredential> signUp(
      String email, String password, String username) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(username);

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } catch (e) {
      throw Exception('Failed to sign up: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
