import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/movie_details_cubit.dart';
import '../widgets/movie_recommendations.dart';

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
                            IconButton(
                              icon: Icon(
                                state.isInWatchlist
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                              ),
                              onPressed: () {
                                // Toggle watchlist
                              },
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