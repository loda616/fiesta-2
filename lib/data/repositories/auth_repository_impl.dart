import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<User> signUp(String email, String password, String username) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final userData = {
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(userData);

      return User(
        id: credential.user!.uid,
        email: email,
        username: username,
      );
    } catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) return null;

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw Exception('Failed to get current user');
    }
  }

  String _handleFirebaseAuthException(dynamic e) {
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Wrong password provided';
        case 'email-already-in-use':
          return 'The email address is already in use';
        case 'invalid-email':
          return 'The email address is invalid';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled';
        case 'weak-password':
          return 'The password provided is too weak';
        default:
          return 'Authentication failed';
      }
    }
    return 'An unexpected error occurred';
  }
}