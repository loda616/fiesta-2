import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/movies/tv_models.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_state.dart';
import '../cubit/tv_show_cubit.dart';
import 'tv_episodes_page.dart';

class TvSeasonsPage extends StatefulWidget {
  final String tvShowId;
  final String title;

  const TvSeasonsPage({
    Key? key,
    required this.tvShowId,
    required this.title,
  }) : super(key: key);

  @override
  State<TvSeasonsPage> createState() => _TvSeasonsPageState();
}

class _TvSeasonsPageState extends State<TvSeasonsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvShowCubit>().loadSeasons(widget.tvShowId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seasons: ${widget.title}'),
      ),
      body: BlocBuilder<TvShowCubit, TvShowState>(
        builder: (context, state) {
          if (state is TvShowLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TvShowError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<TvShowCubit>().loadSeasons(widget.tvShowId),
            );
          }

          if (state is TvShowSeasonsLoaded) {
            if (state.seasons.isEmpty) {
              return const EmptyState(
                message: 'No seasons found',
                icon: Icons.movie_filter_outlined,
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.seasons.length,
              itemBuilder: (context, index) {
                final season = state.seasons[index];
                return _buildSeasonCard(context, season);
              },
            );
          }

          return const EmptyState(
            message: 'Select a TV show to view seasons',
            icon: Icons.tv,
          );
        },
      ),
    );
  }

  Widget _buildSeasonCard(BuildContext context, Season season) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TvEpisodesPage(
                tvShowId: widget.tvShowId,
                seasonNumber: season.number ?? 0,
                seasonName: season.name,
                showTitle: widget.title,
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (season.posterUrl != null && season.posterUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  bottomLeft: Radius.circular(4.r),
                ),
                child: Image.network(
                  season.posterUrl!,
                  width: 120.w,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120.w,
                      height: 180.h,
                      color: Colors.grey[300],
                      child: Icon(Icons.movie, size: 40.sp),
                    );
                  },
                ),
              )
            else
              Container(
                width: 120.w,
                height: 180.h,
                color: Colors.grey[300],
                child: Icon(Icons.movie, size: 40.sp),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      season.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if (season.airDate != null) ...[
                      Text(
                        'Air Date: ${season.airDate}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4.h),
                    ],
                    if (season.episodeCount != null) ...[
                      Text(
                        'Episodes: ${season.episodeCount}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8.h),
                    ],
                    if (season.overview != null && season.overview!.isNotEmpty) ...[
                      Text(
                        season.overview!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TvEpisodesPage(
                                  tvShowId: widget.tvShowId,
                                  seasonNumber: season.number ?? 0,
                                  seasonName: season.name,
                                  showTitle: widget.title,
                                ),
                              ),
                            );
                          },
                          child: Text('View Episodes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}