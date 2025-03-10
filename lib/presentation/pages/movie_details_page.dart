import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/movie_details_cubit.dart';
import '../widgets/movie_recommendations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/streaming_sources_section.dart';
import 'tv_seasons_page.dart';

class MovieDetailsPage extends StatefulWidget {
  final String movieId;

  const MovieDetailsPage({
    Key? key,
    required this.movieId,
  }) : super(key: key);

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
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
            final isTvShow = state.movie.type == 'tv_series' ||
                state.movie.type == 'tv_miniseries' ||
                state.movie.type == 'tv_special';

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.h,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: state.movie.poster.isNotEmpty
                        ? Image.network(
                      state.movie.poster,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.movie,
                        size: 100.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        state.isInWatchlist
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                      ),
                      onPressed: () {
                        context.read<MovieDetailsCubit>().toggleWatchlist();
                      },
                    ),
                    if (isTvShow)
                      IconButton(
                        icon: const Icon(Icons.live_tv),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TvSeasonsPage(
                                tvShowId: state.movie.watchmodeId ?? '',
                                title: state.movie.title,
                              ),
                            ),
                          );
                        },
                        tooltip: 'View Seasons',
                      ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.movie.title,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            if (state.movie.imdbRating != null) ...[
                              Icon(Icons.star, color: Colors.amber, size: 20.sp),
                              SizedBox(width: 4.w),
                              Text(
                                state.movie.imdbRating!,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              SizedBox(width: 16.w),
                            ],
                            Text(
                              state.movie.year,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            if (state.movie.runtime != null) ...[
                              SizedBox(width: 16.w),
                              Text(
                                state.movie.runtime!,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                            if (isTvShow) ...[
                              SizedBox(width: 16.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'TV Show',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (state.movie.genre != null) ...[
                          SizedBox(height: 16.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: state.movie.genre!
                                .split(',')
                                .map((genre) => Chip(
                              label: Text(genre.trim()),
                            ))
                                .toList(),
                          ),
                        ],
                        if (state.movie.streamingSources != null &&
                            state.movie.streamingSources!.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          StreamingSourcesSection(
                            streamingSources: state.movie.streamingSources,
                            onSeeAllPressed: () {
                              // Show all streaming sources in a dialog or new page
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('All Streaming Sources'),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.movie.streamingSources!.length,
                                      itemBuilder: (context, index) {
                                        final source = state.movie.streamingSources![index];
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
                            },
                          ),
                        ],
                        if (state.movie.plot != null) ...[
                          SizedBox(height: 16.h),
                          Text(
                            'Plot',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            state.movie.plot!,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],

                        if (isTvShow) ...[
                          SizedBox(height: 24.h),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.live_tv),
                            label: const Text('View Seasons & Episodes'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TvSeasonsPage(
                                    tvShowId: state.movie.watchmodeId ?? '',
                                    title: state.movie.title,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50.h),
                            ),
                          ),
                        ],

                        SizedBox(height: 24.h),
                        MovieRecommendations(
                          recommendations: state.recommendations,
                        ),
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