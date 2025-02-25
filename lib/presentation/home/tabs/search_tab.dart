import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/datasources/search_local_source.dart';
import '../../cubit/movie_cubit.dart';
import '../../widgets/empty_state.dart' show EmptyState;
import '../../widgets/error_view.dart' show ErrorView;
import '../../widgets/filter_dialogs.dart' show FilterDialogs;
import '../../widgets/movie_grid.dart' show MovieGrid;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../data/datasources/search_local_source.dart';
import '../../cubit/movie_cubit.dart';
import '../../widgets/empty_state.dart' show EmptyState;
import '../../widgets/error_view.dart' show ErrorView;
import '../../widgets/filter_dialogs.dart' show FilterDialogs;
import '../../widgets/movie_grid.dart' show MovieGrid;

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _selectedGenre = 'All';
  String _selectedYear = 'All';
  String _sortBy = 'Rating';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<MovieCubit>().searchMovies(
          query,
          genre: _selectedGenre == 'All' ? null : _selectedGenre,
          year: _selectedYear == 'All' ? null : _selectedYear,
          sortBy: _sortBy,
        );
      }
    });
  }

  void _showGenreFilter() {
    FilterDialogs.showGenreFilter(
      context,
      _selectedGenre,
          (genre) => setState(() {
        _selectedGenre = genre;
        if (_searchController.text.isNotEmpty) {
          _onSearchChanged(_searchController.text);
        }
      }),
    );
  }

  void _showYearFilter() {
    FilterDialogs.showYearFilter(
      context,
      _selectedYear,
          (year) => setState(() {
        _selectedYear = year;
        if (_searchController.text.isNotEmpty) {
          _onSearchChanged(_searchController.text);
        }
      }),
    );
  }

  void _showSortOptions() {
    FilterDialogs.showSortOptions(
      context,
      _sortBy,
          (sort) => setState(() {
        _sortBy = sort;
        if (_searchController.text.isNotEmpty) {
          _onSearchChanged(_searchController.text);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add extra space at the top
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add title above search bar
              Text(
                'Find Movies & Shows',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              SearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
                leading: const Icon(Icons.search),
                trailing: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<MovieCubit>().resetState();
                        setState(() {});
                      },
                    ),
                ],
              ),
              SizedBox(height: 20.h), // Increase space before filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text('Genre: $_selectedGenre'),
                      onSelected: (_) => _showGenreFilter(),
                      selected: _selectedGenre != 'All',
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    ),
                    SizedBox(width: 12.w), // Increase spacing between filters
                    FilterChip(
                      label: Text('Year: $_selectedYear'),
                      onSelected: (_) => _showYearFilter(),
                      selected: _selectedYear != 'All',
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    ),
                    SizedBox(width: 12.w), // Increase spacing between filters
                    FilterChip(
                      label: Text('Sort: $_sortBy'),
                      onSelected: (_) => _showSortOptions(),
                      selected: true,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              if (state is MovieLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is MovieError) {
                return ErrorView(
                  message: state.message,
                  onRetry: () => _onSearchChanged(_searchController.text),
                );
              }
              if (state is MovieSearchLoaded) {
                if (state.movies.isEmpty) {
                  return const EmptyState(
                    message: 'No movies found',
                    icon: Icons.movie_filter_outlined,
                  );
                }
                return MovieGrid(movies: state.movies);
              }
              return _buildSearchHistory();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHistory() {
    final searchHistory = context.read<SearchLocalSource>().getSearchHistory();
    if (searchHistory.isEmpty) {
      return const EmptyState(
        message: 'Search for movies',
        icon: Icons.search,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        final query = searchHistory[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(query),
          onTap: () {
            _searchController.text = query;
            _onSearchChanged(query);
          },
          trailing: IconButton(
            icon: const Icon(Icons.north_west),
            onPressed: () {
              _searchController.text = query;
              _onSearchChanged(query);
            },
          ),
        );
      },
    );
  }
}