import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';
import '../../domain/usecases/get_movies_usecase.dart';
import '../bloc/movie/movie_bloc.dart';

class MovieDetailsPage extends StatelessWidget {
  final String movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(
        getMovies: context.read<GetMoviesUseCase>(),
        getMovieDetails: context.read<GetMovieDetailsUseCase>(),
      )..add(GetMovieDetails(movieId)),
      child: const MovieDetailsView(),
    );
  }
}

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MovieError) {
            return Center(child: Text(state.message));
          }
          if (state is MovieDetailsLoaded) {
            final movie = state.movie;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: movie.poster.isNotEmpty
                        ? Image.network(
                      movie.poster,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, size: 100),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                movie.title,
                                style: theme.textTheme.headlineSmall,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                movie.isInWatchlist
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                              ),
                              onPressed: () {
                                // Handle watchlist toggle
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (movie.imdbRating != null) ...[
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(movie.imdbRating!),
                              const SizedBox(width: 16),
                            ],
                            Text(movie.year),
                            if (movie.runtime != null) ...[
                              const SizedBox(width: 16),
                              Text(movie.runtime!),
                            ],
                          ],
                        ),
                        if (movie.genre != null) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            children: movie.genre!
                                .split(',')
                                .map((genre) => Chip(label: Text(genre.trim())))
                                .toList(),
                          ),
                        ],
                        if (movie.plot != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Plot',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(movie.plot!),
                        ],
                        if (movie.director != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Director',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(movie.director!),
                        ],
                        if (movie.actors != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Cast',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(movie.actors!),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}