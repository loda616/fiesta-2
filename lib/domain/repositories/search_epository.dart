import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/movie.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Movie>>> searchContent(
      String query, {
        String searchField = 'name',
        String? contentType,
      });
}