import 'package:flutter/material.dart';

import 'movie_card.dart';

class CurrentlyWatchingSection extends StatelessWidget {
  const CurrentlyWatchingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Currently Watching',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return MovieCard(
                // TODO: Replace with actual movie data
                title: 'Movie Title',
                poster: '',
                rating: '8.5',
              );
            },
          ),
        ),
      ],
    );
  }
}
