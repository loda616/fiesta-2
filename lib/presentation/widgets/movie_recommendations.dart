import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home/widgets/movie_card.dart' show MovieCard;
import '../pages/movie_details_page.dart' show MovieDetailsPage;

class MovieRecommendations extends StatelessWidget {
  final List<Movie> recommendations;

  const MovieRecommendations({
    Key? key,
    required this.recommendations,
  }) : super(key: key);

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
          height: 200.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final movie = recommendations[index];
              return SizedBox(
                width: 140.w,
                child: MovieCard(
                  movie: movie,
                  onTap: () {
                    // Navigate to movie details
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsPage(
                          movieId: movie.imdbId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}