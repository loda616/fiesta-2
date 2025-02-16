import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.sentiment_dissatisfied,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (onActionPressed != null && actionLabel != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onActionPressed,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}