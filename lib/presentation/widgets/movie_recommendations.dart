import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../bloc/movie/movie_bloc.dart';

class MovieRecommendations extends StatelessWidget {
  final Movie movie;

  const MovieRecommendations({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        // TODO: Implement recommendations logic based on genre and ratings
        return const SizedBox();
      },
    );
  }
}