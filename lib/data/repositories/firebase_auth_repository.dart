import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_source.dart';


class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuthSource _authSource;

  FirebaseAuthRepository(this._authSource);

  @override
  Future<User> signIn(String email, String password) async {
    try {
      final credential = await _authSource.signIn(email, password);
      return User(
        id: credential.user!.uid,
        email: credential.user!.email!,
        username: credential.user!.displayName,
      );
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<User> signUp(String email, String password, String username) async {
    try {
      final credential = await _authSource.signUp(email, password, username);
      return User(
        id: credential.user!.uid,
        email: credential.user!.email!,
        username: username,
      );
    } catch (e) {
      throw Exception('Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authSource.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final user = _authSource.currentUser;
      if (user != null) {
        return User(
          id: user.uid,
          email: user.email!,
          username: user.displayName,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Stream<User?> get authStateChanges => _authSource.authStateChanges.map((user) {
    if (user == null) return null;
    return User(
      id: user.uid,
      email: user.email!,
      username: user.displayName,
    );
  });
}

// lib/data/datasources/firebase_auth_source.dart
