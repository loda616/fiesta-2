import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/movie.dart' show Movie;
import '../../cubit/movie_cubit.dart';
import '../../widgets/empty_state.dart' show EmptyState;
import '../../widgets/error_view.dart';
import '../../widgets/filter_dialogs.dart' show FilterDialogs;
import '../../widgets/responsive_movie_card.dart'; // Import the ResponsiveMovieCard


class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _selectedGenre = 'All';
  String _selectedYear = 'All';
  String _sortBy = 'Rating';
  String? _contentType;

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

  void _showContentTypeFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Content Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String?>(
              title: const Text('All'),
              value: null,
              groupValue: _contentType,
              onChanged: (value) {
                setState(() {
                  _contentType = value;
                });
                Navigator.pop(context);
                if (_searchController.text.isNotEmpty) {
                  _onSearchChanged(_searchController.text);
                }
              },
            ),
            RadioListTile<String?>(
              title: const Text('Movies'),
              value: 'movie',
              groupValue: _contentType,
              onChanged: (value) {
                setState(() {
                  _contentType = value;
                });
                Navigator.pop(context);
                if (_searchController.text.isNotEmpty) {
                  _onSearchChanged(_searchController.text);
                }
              },
            ),
            RadioListTile<String?>(
              title: const Text('TV Shows'),
              value: 'tv',
              groupValue: _contentType,
              onChanged: (value) {
                setState(() {
                  _contentType = value;
                });
                Navigator.pop(context);
                if (_searchController.text.isNotEmpty) {
                  _onSearchChanged(_searchController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // Add extra space at the top
        SizedBox(height: 16.h),
        Padding(
          // Use responsive padding
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 600 ? 24.w : 12.w,
              vertical: 8.h
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add title above search bar
              SizedBox(height: 50),
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
                // Make SearchBar width match parent
                constraints: const BoxConstraints(
                  maxWidth: double.infinity,
                ),
              ),
              SizedBox(height: 20.h), // Increase space before filters
              // Wrap with a container with overflow fix
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text('Type: ${_contentTypeLabel()}'),
                        onSelected: (_) => _showContentTypeFilter(),
                        selected: _contentType != null,
                      ),
                      SizedBox(width: 12.w), // Increase spacing between filters
                      FilterChip(
                        label: Text('Genre: $_selectedGenre'),
                        onSelected: (_) => _showGenreFilter(),
                        selected: _selectedGenre != 'All',
                      ),
                      SizedBox(width: 12.w), // Increase spacing between filters
                      FilterChip(
                        label: Text('Year: $_selectedYear'),
                        onSelected: (_) => _showYearFilter(),
                        selected: _selectedYear != 'All',
                      ),
                      SizedBox(width: 12.w), // Increase spacing between filters
                      FilterChip(
                        label: Text('Sort: $_sortBy'),
                        onSelected: (_) => _showSortOptions(),
                        selected: true,
                      ),
                      // Add end padding to prevent overflow
                      SizedBox(width: 4.w),
                    ],
                  ),
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
              if (state is SearchResultsLoaded) {
                if (state.movies.isEmpty) {
                  return const EmptyState(
                    message: 'No movies found',
                    icon: Icons.movie_filter_outlined,
                  );
                }
                return _buildMovieGrid(state.movies);
              }
              return const EmptyState(
                message: 'Search for movies',
                icon: Icons.search,
              );
            },
          ),
        ),
      ],
    );
  }

  // Movie grid using the imported ResponsiveMovieCard
  Widget _buildMovieGrid(List<Movie> movies) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ResponsiveMovieCard(
          movie: movie,
          onTap: () {
            Navigator.pushNamed(
              context,
              '/movie_details',
              arguments: movie.watchmodeId ?? movie.imdbId,
            );
          },
        );
      },
    );
  }

  String _contentTypeLabel() {
    if (_contentType == null) return 'All';
    if (_contentType == 'movie') return 'Movies';
    if (_contentType == 'tv') return 'TV Shows';
    return _contentType!;
  }
}