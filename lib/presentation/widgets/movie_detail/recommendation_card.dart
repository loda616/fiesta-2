import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/movie.dart';

class RecommendationCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const RecommendationCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 140.w,
      margin: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: AspectRatio(
                aspectRatio: 2/3,
                child: movie.poster.isNotEmpty
                    ? Image.network(
                  movie.poster,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: theme.colorScheme.surface,
                    child: Icon(Icons.movie, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  ),
                )
                    : Container(
                  color: theme.colorScheme.surface,
                  child: Icon(Icons.movie, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                if (movie.imdbRating != null) ...[
                  Icon(Icons.star, size: 14.sp, color: Colors.amber),
                  SizedBox(width: 4.w),
                  Text(
                    movie.imdbRating!,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(
                  movie.year,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
