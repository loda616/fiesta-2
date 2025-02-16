import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password, String username);
  Future<void> signOut();
  Future<User?> getCurrentUser();
}