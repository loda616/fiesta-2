import 'package:fiesta/presentation/widgets/movie_grid.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';

class MovieGridPage extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const MovieGridPage({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: MovieGrid(movies: movies),
    );
  }
}