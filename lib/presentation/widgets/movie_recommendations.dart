// lib/presentation/widgets/movie_recommendations.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/movie.dart';

class MovieRecommendations extends StatelessWidget {
  final List<Movie> recommendations;

  const MovieRecommendations({
    super.key,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You might also like',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 220.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final movie = recommendations[index];
              return RecommendationCard(movie: movie);
            },
          ),
        ),
      ],
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final Movie movie;

  const RecommendationCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          '/movie_details',
          arguments: movie.watchmodeId ?? movie.imdbId,
        );
      },
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8.r),
              ),
              child: SizedBox(
                height: 150.h,
                width: 140.w,
                child: movie.poster.isNotEmpty
                    ? Image.network(
                  movie.poster,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[700],
                    child: Icon(Icons.movie, size: 40.sp, color: Colors.white54),
                  ),
                )
                    : Container(
                  color: Colors.grey[700],
                  child: Icon(Icons.movie, size: 40.sp, color: Colors.white54),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (movie.imdbRating != null) ...[
                        Icon(Icons.star, size: 12.sp, color: Colors.amber),
                        SizedBox(width: 2.w),
                        Text(
                          movie.imdbRating!,
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        movie.year,
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}