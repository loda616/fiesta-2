import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/movie.dart';

class ShareButton extends StatelessWidget {
  final Movie movie;

  const ShareButton({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () {
        Share.share(
          'Check out ${movie.title} (${movie.year})\nIMDb Rating: ${movie.imdbRating ?? "N/A"}',
        );
      },
    );
  }
}