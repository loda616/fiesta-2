import 'package:flutter/material.dart';

import '../widgets/movie_card.dart';

class WatchlistTab extends StatelessWidget {
  const WatchlistTab({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Watchlist'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Want to Watch'),
              Tab(text: 'Watched'),
            ],
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
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return MovieCard(
          title: 'Movie Title',
          poster: '',
          rating: '8.5',
        );
      },
    );
  }
}
