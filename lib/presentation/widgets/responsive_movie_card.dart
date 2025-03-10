import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/movie.dart';

class ResponsiveMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const ResponsiveMovieCard({
    Key? key,
    required this.movie,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Responsive dimensions
    final cardWidth = 160.w;
    final cardHeight = 240.h;
    final borderRadius = 12.r;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              // Poster image
              Positioned.fill(
                child: movie.poster.isNotEmpty
                    ? Image.network(
                  movie.poster,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: Icon(Icons.movie, size: 50.sp, color: Colors.white54),
                  ),
                )
                    : Container(
                  color: Colors.grey[800],
                  child: Icon(Icons.movie, size: 50.sp, color: Colors.white54),
                ),
              ),
              // Gradient overlay for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Movie info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Year and rating
                      Row(
                        children: [
                          if (movie.imdbRating != null) ...[
                            Icon(Icons.star, size: 14.sp, color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(
                              movie.imdbRating!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                          Icon(Icons.calendar_today, size: 14.sp, color: Colors.white70),
                          SizedBox(width: 4.w),
                          Text(
                            movie.year,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      // Type badge (movie/tv show)
                      if (movie.type != null) ...[
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            movie.type!.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}