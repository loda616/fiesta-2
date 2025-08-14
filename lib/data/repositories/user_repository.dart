import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_strings.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateWatchlist(String userId, List<String> watchlist) async {
    await _firestore.collection('users').doc(userId).update({
      AppStrings.watchlist: watchlist,
    });
  }

  Future<void> updateWatched(String userId, List<String> watched) async {
    await _firestore.collection('users').doc(userId).update({
      AppStrings.watched: watched,
    });
  }
}