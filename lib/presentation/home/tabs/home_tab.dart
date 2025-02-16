import 'package:fiesta/presentation/home/tabs/sections/popular_movies_section.dart';
import 'package:flutter/material.dart';
import '../widgets/currently_watching_section.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
    );
  }
}