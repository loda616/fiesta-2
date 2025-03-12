import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieBackdrop extends StatelessWidget {
  final String? backdropUrl;
  final String? posterUrl;

  const MovieBackdrop({
    super.key,
    this.backdropUrl,
    this.posterUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            theme.scaffoldBackgroundColor,
          ],
          stops: const [0.7, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: _buildImage(theme),
    );
  }

  Widget _buildImage(ThemeData theme) {
    // First try to use backdrop, then poster, then fallback
    if (backdropUrl != null && backdropUrl!.isNotEmpty) {
      return Image.network(
        backdropUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPosterOrFallback(theme),
      );
    }
    return _buildPosterOrFallback(theme);
  }

  Widget _buildPosterOrFallback(ThemeData theme) {
    if (posterUrl != null && posterUrl!.isNotEmpty) {
      return Image.network(
        posterUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(theme),
      );
    }
    return _buildFallback(theme);
  }

  Widget _buildFallback(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: Icon(
        Icons.movie,
        size: 100.sp,
        color: theme.colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }
}