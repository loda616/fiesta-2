import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/movie.dart';
import 'section_header.dart';
import 'streaming_source_list.dart';

class WhereToWatchSection extends StatelessWidget {
  final List<StreamingSource> sources;
  final VoidCallback onViewAllPressed;

  const WhereToWatchSection({
    super.key,
    required this.sources,
    required this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Where to Watch',
          onMorePressed: sources.length > 3 ? onViewAllPressed : null,
        ),
        SizedBox(height: 8.h),
        StreamingSourceList(
          sources: sources,
          maxToShow: 3,
        ),
      ],
    );
  }
}