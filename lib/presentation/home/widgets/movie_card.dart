import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String poster;
  final String rating;

  const MovieCard({
    super.key,
    required this.title,
    required this.poster,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: poster.isNotEmpty
                  ? Image.network(poster, fit: BoxFit.cover)
                  : Container(
                color: Colors.grey[300],
                child: const Icon(Icons.movie),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(rating),
            ],
          ),
        ],
      ),
    );
  }
}