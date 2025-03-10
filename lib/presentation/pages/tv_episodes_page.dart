import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/movies/tv_models.dart' show Episode;
import '../widgets/error_view.dart';
import '../widgets/empty_state.dart';
import '../cubit/tv_show_cubit.dart';
import 'episode_details_page.dart';

class TvEpisodesPage extends StatefulWidget {
  final String tvShowId;
  final int seasonNumber;
  final String seasonName;
  final String showTitle;

  const TvEpisodesPage({
    Key? key,
    required this.tvShowId,
    required this.seasonNumber,
    required this.seasonName,
    required this.showTitle,
  }) : super(key: key);

  @override
  State<TvEpisodesPage> createState() => _TvEpisodesPageState();
}

class _TvEpisodesPageState extends State<TvEpisodesPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvShowCubit>().loadEpisodes(
      widget.tvShowId,
      widget.seasonNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.showTitle}: ${widget.seasonName}'),
      ),
      body: BlocBuilder<TvShowCubit, TvShowState>(
        builder: (context, state) {
          if (state is TvShowLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TvShowError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<TvShowCubit>().loadEpisodes(
                widget.tvShowId,
                widget.seasonNumber,
              ),
            );
          }

          if (state is TvShowEpisodesLoaded) {
            if (state.episodes.isEmpty) {
              return const EmptyState(
                message: 'No episodes found',
                icon: Icons.movie_filter_outlined,
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.episodes.length,
              itemBuilder: (context, index) {
                final episode = state.episodes[index];
                return _buildEpisodeCard(context, episode);
              },
            );
          }

          return const EmptyState(
            message: 'Select a season to view episodes',
            icon: Icons.video_library,
          );
        },
      ),
    );
  }

  Widget _buildEpisodeCard(BuildContext context, Episode episode) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeDetailsPage(
                episode: episode,
                showTitle: widget.showTitle,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (episode.thumbnailUrl != null && episode.thumbnailUrl!.isNotEmpty)
              Image.network(
                episode.thumbnailUrl!,
                width: double.infinity,
                height: 180.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 180.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.movie, size: 40.sp),
                  );
                },
              )
            else
              Container(
                width: double.infinity,
                height: 180.h,
                color: Colors.grey[300],
                child: Icon(Icons.movie, size: 40.sp),
              ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Episode ${episode.episodeNumber}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      if (episode.releaseDate != null) ...[
                        Text(
                          episode.releaseDate!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    episode.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (episode.runtimeMinutes != null) ...[
                    Text(
                      'Runtime: ${episode.runtimeMinutes} min',
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8.h),
                  ],
                  if (episode.overview != null && episode.overview!.isNotEmpty) ...[
                    Text(
                      episode.overview!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  if (episode.sources != null && episode.sources!.isNotEmpty) ...[
                    Wrap(
                      spacing: 8.w,
                      children: episode.sources!.take(3).map((source) {
                        return Chip(
                          label: Text(
                            source.name,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          backgroundColor: _getSourceColor(source.type).withOpacity(0.2),
                        );
                      }).toList(),
                    ),
                    if (episode.sources!.length > 3) ...[
                      Text(
                        '+ ${episode.sources!.length - 3} more sources',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSourceColor(String type) {
    switch (type) {
      case 'sub':
        return Colors.blue;
      case 'free':
        return Colors.green;
      case 'rent':
        return Colors.orange;
      case 'buy':
        return Colors.purple;
      case 'tve':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}