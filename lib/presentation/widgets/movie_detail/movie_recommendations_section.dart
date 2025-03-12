import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/movie.dart';
import 'recommendation_card.dart';
import 'section_header.dart';

class MovieRecommendationsSection extends StatelessWidget {
  final List<Movie> recommendations;
  final Function(String movieId) onMovieSelected;

  const MovieRecommendationsSection({
    super.key,
    required this.recommendations,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'You Might Also Like'),
        SizedBox(height: 16.h),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = recommendations[index];
              return RecommendationCard(
                movie: recommendation,
                onTap: () => onMovieSelected(recommendation.watchmodeId ?? recommendation.imdbId),
              );
            },
          ),
        ),
      ],
    );
  }
}