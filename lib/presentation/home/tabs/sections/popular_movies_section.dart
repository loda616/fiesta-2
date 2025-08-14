import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../cubit/movie_cubit.dart' show MovieCubit, MovieError, MovieLoading, PopularMoviesLoaded, MovieState;
import '../../widgets/movie_card.dart' show MovieCard;


class PopularMoviesSection extends StatefulWidget {
  const PopularMoviesSection({Key? key}) : super(key: key);

  @override
  State<PopularMoviesSection> createState() => _PopularMoviesSectionState();
}

class _PopularMoviesSectionState extends State<PopularMoviesSection> {
  @override
  void initState() {
    super.initState();
    context.read<MovieCubit>().loadPopularMovies();
  }

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
                'Popular Movies',
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
        BlocBuilder<MovieCubit, MovieState>(
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
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
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
                        'Failed to load popular movies',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<MovieCubit>().loadPopularMovies();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is PopularMoviesLoaded) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                ),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieCard(
                    movie: movie,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/movie_details',
                        arguments: movie.watchmodeId ?? movie.imdbId,
                      );
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}