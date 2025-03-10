import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/movie.dart';


class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final bool isLoading;

  const MovieGrid({
    super.key,
    required this.movies,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive padding based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth > 600 ? 16.w : 8.w;

    return GridView.builder(
      padding: EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,  // Consistent aspect ratio
        crossAxisSpacing: padding,
        mainAxisSpacing: padding,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieCard(movie: movie);
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: movie.poster.isNotEmpty
                ? Image.network(
              movie.poster,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie),
                );
              },
            )
                : Container(
              color: Colors.grey[300],
              child: const Icon(Icons.movie),
            ),
          ),
        ],
      ),
    );
  }
}