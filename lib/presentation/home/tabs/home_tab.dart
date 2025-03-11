import 'package:fiesta/presentation/home/tabs/sections/popular_movies_section.dart' show PopularMoviesSection;
import 'package:flutter/material.dart';
import 'sections/currently_watching_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/movie_cubit.dart';


class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Reload all sections
        final movieCubit = context.read<MovieCubit>();
        await Future.wait([
          movieCubit.loadCurrentlyWatching(),
          movieCubit.loadPopularMovies(),
        ]);
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('WatchList'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),
          const SliverToBoxAdapter(
            child: CurrentlyWatchingSection(),
          ),
          const SliverToBoxAdapter(
            child: PopularMoviesSection(),
          ),
        ],
      ),
    );
  }
}

