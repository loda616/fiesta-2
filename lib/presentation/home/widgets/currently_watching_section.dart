import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/movie_cubit.dart';
import '../widgets/movie_card.dart';

class CurrentlyWatchingSection extends StatelessWidget {
  const CurrentlyWatchingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Currently Watching',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full list
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200.h,
          child: BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              if (state is MovieLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }

              if (state is MovieError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.sp,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Failed to load movies',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Retry loading
                          context.read<MovieCubit>().loadCurrentlyWatching();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is MovieSearchLoaded && state.movies.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie_outlined,
                        size: 48.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'No movies in your watchlist',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to search or recommendations
                        },
                        child: const Text('Discover Movies'),
                      ),
                    ],
                  ),
                );
              }

              // Show movies in horizontal list
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemCount: state is MovieSearchLoaded ? state.movies.length : 0,
                separatorBuilder: (context, index) => SizedBox(width: 16.w),
                itemBuilder: (context, index) {
                  if (state is MovieSearchLoaded) {
                    final movie = state.movies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () {
                        // Navigate to movie details
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}