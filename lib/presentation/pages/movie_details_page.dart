// lib/presentation/pages/movie_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/watchmode_models.dart' show StreamingSource;
import '../cubit/movie_details_cubit.dart';
import '../widgets/movie_detail/action_button.dart';
import '../widgets/movie_detail/genre_chips.dart';
import '../widgets/movie_detail/info_badge.dart';
import '../widgets/movie_detail/movie_backdrop.dart';
import '../widgets/movie_detail/movie_recommendations_section.dart';
import '../widgets/movie_detail/section_header.dart';
import '../widgets/movie_detail/where_to_watch_section.dart';
import 'tv_seasons_page.dart';

class MovieDetailsPage extends StatefulWidget {
  final String movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieDetailsCubit>().loadMovieDetails(widget.movieId);
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  void _navigateToMovieDetails(String movieId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movieId: movieId),
      ),
    );
  }

  void _showAllStreamingSources(List<StreamingSource> sources) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Streaming Sources'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sources.length,
            itemBuilder: (context, index) {
              final source = sources[index];
              return ListTile(
                title: Text(source.name),
                subtitle: Text(source.type),
                trailing: source.price != null && source.price!.isNotEmpty
                    ? Text('\$${source.price}')
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  if (source.webUrl.isNotEmpty) {
                    _launchUrl(source.webUrl);
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: theme.colorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<MovieDetailsCubit>()
                          .loadMovieDetails(widget.movieId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MovieDetailsLoaded) {
            final movie = state.movie;
            final isTvShow = movie.type == 'tv_series' ||
                movie.type == 'tv_miniseries' ||
                movie.type == 'tv_special';

            return CustomScrollView(
              slivers: [
                // Custom app bar with image
                SliverAppBar(
                  expandedHeight: 300.h,
                  pinned: true,
                  leading: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          state.isInWatchlist
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        context.read<MovieDetailsCubit>().toggleWatchlist();
                      },
                    ),
                    SizedBox(width: 8.w),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: MovieBackdrop(
                      backdropUrl: movie.backdrop,
                      posterUrl: movie.poster,
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title section
                        Text(
                          movie.title,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Info badges
                        Wrap(
                          spacing: 12.w,
                          children: [
                            if (movie.imdbRating != null)
                              InfoBadge(
                                icon: Icons.star,
                                text: '${movie.imdbRating!} / 10',
                                iconColor: Colors.amber,
                              ),
                            InfoBadge(
                              icon: Icons.calendar_today,
                              text: movie.year,
                            ),
                            if (movie.runtime != null)
                              InfoBadge(
                                icon: Icons.access_time,
                                text: movie.runtime!,
                              ),
                            if (isTvShow)
                              InfoBadge(
                                icon: Icons.live_tv,
                                text: 'TV Show',
                                iconColor: theme.colorScheme.primary,
                                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                              ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // Three action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ActionButton(
                                icon: Icons.bookmark,
                                label: state.isInWatchlist ? 'In Watchlist' : 'To Watch',
                                onPressed: () {
                                  context.read<MovieDetailsCubit>().toggleWatchlist();
                                },
                                isActive: state.isInWatchlist,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: ActionButton(
                                icon: Icons.list_alt,
                                label: 'Episodes',
                                onPressed: isTvShow ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TvSeasonsPage(
                                        tvShowId: movie.watchmodeId ?? '',
                                        title: movie.title,
                                      ),
                                    ),
                                  );
                                } : null,
                                isDisabled: !isTvShow,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: ActionButton(
                                icon: Icons.share,
                                label: 'Share',
                                onPressed: () {
                                  // Implement share functionality
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // Where to watch section
                        if (movie.streamingSources != null && movie.streamingSources!.isNotEmpty)
                          WhereToWatchSection(
                            sources: movie.streamingSources!,
                            onViewAllPressed: () => _showAllStreamingSources(movie.streamingSources!.cast<StreamingSource>()),
                          ),

                        SizedBox(height: 24.h),

                        // Overview section with heading
                        if (movie.plot != null && movie.plot!.isNotEmpty) ...[
                          SectionHeader(title: 'Overview'),
                          SizedBox(height: 8.h),
                          Text(
                            movie.plot!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],

                        // Genre chips
                        if (movie.genreNames != null && movie.genreNames!.isNotEmpty) ...[
                          GenreChipsSection(genres: movie.genreNames),
                          SizedBox(height: 24.h),
                        ],

                        // Trailer button
                        if (movie.trailer != null && movie.trailer!.isNotEmpty) ...[
                          ElevatedButton.icon(
                            icon: const Icon(Icons.play_circle_outline),
                            label: const Text('Watch Trailer'),
                            onPressed: () {
                              _launchUrl(movie.trailer!);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50.h),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],

                        // Recommendations section
                        if (state.recommendations.isNotEmpty) ...[
                          MovieRecommendationsSection(
                            recommendations: state.recommendations,
                            onMovieSelected: _navigateToMovieDetails,
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}