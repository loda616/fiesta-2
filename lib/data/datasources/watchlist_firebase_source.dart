import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/movie_model.dart';

class WatchlistFirebaseSource {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  WatchlistFirebaseSource({
    FirebaseFirestore? firestore,
    firebase_auth.FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  Future<void> addToWatchlist(MovieModel movie) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('watchlist')
        .doc(movie.imdbId)
        .set({
      ...movie.toJson(),
      'addedAt': FieldValue.serverTimestamp(),
      'watched': false,
    });
  }

  Future<void> removeFromWatchlist(String movieId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('watchlist')
        .doc(movieId)
        .delete();
  }

  Future<void> markAsWatched(String movieId, bool watched) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('watchlist')
        .doc(movieId)
        .update({'watched': watched});
  }

  Stream<List<MovieModel>> getWatchlist() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('watchlist')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MovieModel.fromJson({...doc.data(), 'imdbID': doc.id}))
          .toList();
    });
  }
}