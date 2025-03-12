import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/movie.dart';
import 'package:url_launcher/url_launcher.dart';

class StreamingSourceList extends StatelessWidget {
  final List<StreamingSource> sources;
  final int maxToShow;
  final VoidCallback? onViewAllPressed;

  const StreamingSourceList({
    super.key,
    required this.sources,
    this.maxToShow = 3,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayedSources = sources.length > maxToShow ? sources.sublist(0, maxToShow) : sources;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: displayedSources.map((source) => _buildSourceTile(context, source)).toList(),
      ),
    );
  }

  Widget _buildSourceTile(BuildContext context, StreamingSource source) {
    final theme = Theme.of(context);

    final isSubscription = source.type == 'sub';
    final isFree = source.type == 'free';

    IconData iconData;
    Color iconColor;

    if (isSubscription) {
      iconData = Icons.subscriptions;
      iconColor = Colors.blue;
    } else if (isFree) {
      iconData = Icons.money_off;
      iconColor = Colors.green;
    } else if (source.type == 'rent') {
      iconData = Icons.monetization_on;
      iconColor = Colors.orange;
    } else if (source.type == 'buy') {
      iconData = Icons.shopping_cart;
      iconColor = Colors.purple;
    } else {
      iconData = Icons.play_circle_outline;
      iconColor = theme.colorScheme.primary;
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(iconData, color: iconColor),
      ),
      title: Text(source.name),
      subtitle: Text(
        isSubscription ? 'Subscription' : isFree ? 'Free' : source.format,
        style: TextStyle(fontSize: 12.sp),
      ),
      trailing: source.price != null && source.price!.isNotEmpty
          ? Text(
        '\$${source.price}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      )
          : Text(
        isSubscription ? 'Included' : isFree ? 'Free' : '',
      ),
      onTap: () {
        if (source.webUrl.isNotEmpty) {
          _launchUrl(source.webUrl);
        }
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
