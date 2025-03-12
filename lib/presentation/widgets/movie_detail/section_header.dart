import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMorePressed;
  final String? moreText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onMorePressed,
    this.moreText = 'View All',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onMorePressed != null)
          TextButton(
            onPressed: onMorePressed,
            child: Text(
              moreText!,
              style: TextStyle(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}