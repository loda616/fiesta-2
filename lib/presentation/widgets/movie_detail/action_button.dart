import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isActive;
  final bool isDisabled;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isActive ? theme.colorScheme.primary.withOpacity(0.1) : theme.colorScheme.surface,
        foregroundColor: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24.sp),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}