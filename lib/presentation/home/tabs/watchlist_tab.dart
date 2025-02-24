import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/movie_cubit.dart';
import '../widgets/movie_card.dart';

class WatchlistTab extends StatelessWidget {
  const WatchlistTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Watchlist',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Want to Watch',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              Tab(
                child: Text(
                  'Watched',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        body: TabBarView(
          children: [
            _WatchlistGrid(isWatched: false),
            _WatchlistGrid(isWatched: true),
          ],
        ),
      ),
    );
  }
}

class _WatchlistGrid extends StatelessWidget {
  final bool isWatched;

  const _WatchlistGrid({required this.isWatched});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
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
                  'Failed to load watchlist',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14.sp,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Retry loading
                    context.read<MovieCubit>().loadWatchlist(isWatched: isWatched);
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
                  isWatched ? 'No watched movies yet' : 'Your watchlist is empty',
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

        return GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: state is MovieSearchLoaded ? state.movies.length : 0,
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
    );
  }
}