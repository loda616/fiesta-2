import 'package:fiesta/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieListTile extends StatelessWidget {
  final Movie movie;

  const MovieListTile({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: movie.poster.isNotEmpty
          ? Image.network(
        movie.poster,
        width: 50,
        height: 75,
        fit: BoxFit.cover,
      )
          : Container(
        width: 50,
        height: 75,
        color: Colors.grey[300],
        child: const Icon(Icons.movie),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.year),
      trailing: IconButton(
        icon: Icon(
          movie.isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
        ),
        onPressed: () {
          // Handle watchlist toggle
        },
      ),
      onTap: () {
        // Navigate to movie details
      },
    );
  }
}