import 'package:flutter/material.dart';

class FilterDialogs {
  static void showGenreFilter(BuildContext context, String currentGenre, Function(String) onSelect) {
    final genres = [
      'All',
      'Action',
      'Adventure',
      'Comedy',
      'Drama',
      'Horror',
      'Sci-Fi',
      'Thriller',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Genre'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final genre = genres[index];
              return ListTile(
                title: Text(genre),
                trailing: genre == currentGenre ? const Icon(Icons.check) : null,
                onTap: () {
                  onSelect(genre);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  static void showYearFilter(BuildContext context, String currentYear, Function(String) onSelect) {
    final currentDateTime = DateTime.now();
    final years = ['All', ...List.generate(20, (index) => (currentDateTime.year - index).toString())];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Year'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: years.length,
            itemBuilder: (context, index) {
              final year = years[index];
              return ListTile(
                title: Text(year),
                trailing: year == currentYear ? const Icon(Icons.check) : null,
                onTap: () {
                  onSelect(year);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  static void showSortOptions(BuildContext context, String currentSort, Function(String) onSelect) {
    final sortOptions = [
      'Rating',
      'Year',
      'Title',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort By'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sortOptions.length,
            itemBuilder: (context, index) {
              final option = sortOptions[index];
              return ListTile(
                title: Text(option),
                trailing: option == currentSort ? const Icon(Icons.check) : null,
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}