import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';

class MovieInfoSection extends StatelessWidget {
  final Movie movie;
  final VoidCallback onWatchlistToggle;

  const MovieInfoSection({
    super.key,
    required this.movie,
    required this.onWatchlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                movie.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                movie.isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                color: theme.colorScheme.primary,
              ),
              onPressed: onWatchlistToggle,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (movie.imdbRating != null) ...[
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Text(movie.imdbRating!),
              const SizedBox(width: 16),
              Text(movie.year),
              if (movie.runtime != null) ...[
                const SizedBox(width: 16),
                Text(movie.runtime!),
              ],
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (movie.genre != null) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: movie.genre!
                .split(',')
                .map((genre) => Chip(
              label: Text(
                genre.trim(),
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              backgroundColor: theme.colorScheme.primary,
            ))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (movie.plot != null) ...[
          Text(
            'Plot',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(movie.plot!),
          const SizedBox(height: 16),
        ],
        if (movie.director != null) ...[
          Text(
            'Director',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(movie.director!),
          const SizedBox(height: 16),
        ],
        if (movie.actors != null) ...[
          Text(
            'Cast',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(movie.actors!),
        ],
      ],
    );
  }
}