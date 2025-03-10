import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/movies/tv_models.dart';

class EpisodeDetailsPage extends StatelessWidget {
  final Episode episode;
  final String showTitle;

  const EpisodeDetailsPage({
    super.key,
    required this.episode,
    required this.showTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('$showTitle: ${episode.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (episode.thumbnailUrl != null && episode.thumbnailUrl!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 220.h,
                child: Image.network(
                  episode.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.movie, size: 60.sp),
                    );
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 220.h,
                color: Colors.grey[300],
                child: Icon(Icons.movie, size: 60.sp),
              ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'S${episode.seasonNumber} E${episode.episodeNumber}',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      if (episode.releaseDate != null) ...[
                        Text(
                          episode.releaseDate!,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                      SizedBox(width: 12.w),
                      if (episode.runtimeMinutes != null) ...[
                        Text(
                          '${episode.runtimeMinutes} min',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 16.h),
                  if (episode.overview != null && episode.overview!.isNotEmpty) ...[
                    Text(
                      'Overview',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      episode.overview!,
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 24.h),
                  ],
                  if (episode.sources != null && episode.sources!.isNotEmpty) ...[
                    Text(
                      'Where to Watch',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: episode.sources!.length,
                      itemBuilder: (context, index) {
                        final source = episode.sources![index];
                        return _buildSourceCard(context, source);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceCard(BuildContext context, EpisodeSource source) {
    Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: _getSourceIcon(source.type),
        title: Text(source.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getSourceTypeText(source.type),
              style: TextStyle(
                color: _getSourceColor(source.type),
                fontSize: 12.sp,
              ),
            ),
            if (source.format.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Text(
                'Format: ${source.format}',
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ],
        ),
        trailing: source.price != null
            ? Text(
          '\$${source.price}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        )
            : Text(
          _getPriceText(source.type),
          style: TextStyle(
            color: _getSourceColor(source.type),
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        onTap: () {
          if (source.webUrl != null && source.webUrl!.isNotEmpty) {
            // Launch URL using package like url_launcher
            // For now, just show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${source.name}'),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {},
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _getSourceIcon(String type) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'sub':
        iconData = Icons.subscriptions;
        color = Colors.blue;
        break;
      case 'free':
        iconData = Icons.money_off;
        color = Colors.green;
        break;
      case 'rent':
        iconData = Icons.monetization_on;
        color = Colors.orange;
        break;
      case 'buy':
        iconData = Icons.shopping_cart;
        color = Colors.purple;
        break;
      case 'tve':
        iconData = Icons.tv;
        color = Colors.teal;
        break;
      default:
        iconData = Icons.play_circle_outline;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(iconData, color: color),
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

  String _getSourceTypeText(String type) {
    switch (type) {
      case 'sub':
        return 'Subscription';
      case 'free':
        return 'Free';
      case 'rent':
        return 'Rental';
      case 'buy':
        return 'Purchase';
      case 'tve':
        return 'TV Everywhere';
      default:
        return 'Unknown';
    }
  }

  String _getPriceText(String type) {
    switch (type) {
      case 'sub':
        return 'Included';
      case 'free':
        return 'Free';
      case 'tve':
        return 'TV Login';
      default:
        return 'Varies';
    }
  }
}