
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/movie.dart';

class StreamingSourcesSection extends StatelessWidget {
  final List<StreamingSource>? streamingSources;
  final VoidCallback? onSeeAllPressed;

  const StreamingSourcesSection({
    super.key,
    required this.streamingSources,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (streamingSources == null || streamingSources!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Where to Watch',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            if (streamingSources!.length > 5 && onSeeAllPressed != null)
              TextButton(
                onPressed: onSeeAllPressed,
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 14.sp,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: streamingSources!.take(5).map((source) {
            return _buildSourceItem(context, source);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSourceItem(BuildContext context, StreamingSource source) {
    final theme = Theme.of(context);

    // Determine chip color based on source type
    Color chipColor;
    IconData iconData;
    switch (source.type) {
      case 'sub':
        chipColor = Colors.blue;
        iconData = Icons.subscriptions;
        break;
      case 'free':
        chipColor = Colors.green;
        iconData = Icons.money_off;
        break;
      case 'rent':
        chipColor = Colors.orange;
        iconData = Icons.monetization_on;
        break;
      case 'buy':
        chipColor = Colors.purple;
        iconData = Icons.shopping_cart;
        break;
      case 'tve':
        chipColor = Colors.teal;
        iconData = Icons.tv;
        break;
      default:
        chipColor = theme.colorScheme.primary;
        iconData = Icons.play_circle_outline;
    }

    return InkWell(
      onTap: () {
        if (source.webUrl.isNotEmpty) {
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: chipColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: chipColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 16.sp,
              color: chipColor,
            ),
            SizedBox(width: 6.w),
            Text(
              source.name,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (source.price != null && source.price!.isNotEmpty) ...[
              SizedBox(width: 4.w),
              Text(
                '(\$${source.price})',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}