import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/movie.dart';
import '../repositories/search_epository.dart' show SearchRepository;

class SearchUseCase {
  final SearchRepository repository;

  SearchUseCase(this.repository);

  Future<Either<Failure, List<Movie>>> execute(
      String query, {
        String? contentType,
      }) {
    if (query.isEmpty) {
      return Future.value(const Right([]));
    }

    return repository.searchContent(
      query,
      contentType: contentType,
    );
  }
}