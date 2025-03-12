import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'section_header.dart';

class GenreChipsSection extends StatelessWidget {
  final List<String>? genres;

  const GenreChipsSection({
    super.key,
    this.genres,
  });

  @override
  Widget build(BuildContext context) {
    if (genres == null || genres!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Genres'),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: genres!
              .map((genre) => Chip(
            label: Text(genre.trim()),
            backgroundColor: theme.colorScheme.surface,
            side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
          ))
              .toList(),
        ),
      ],
    );
  }
}
