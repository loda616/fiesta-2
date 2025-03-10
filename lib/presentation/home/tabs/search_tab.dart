import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/datasources/search_local_source.dart';
import '../../cubit/movie_cubit.dart';
import '../../widgets/empty_state.dart' show EmptyState;
import '../../widgets/error_view.dart' show ErrorView;
import '../../widgets/filter_dialogs.dart' show FilterDialogs;
import '../../../domain/entities/movie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              if (state is MovieSearchLoaded) {
                if (state.movies.isEmpty) {
                  return const EmptyState(
                    message: 'No movies found',
                    icon: Icons.movie_filter_outlined,
                  );
                }
                return _buildMovieGrid(state.movies);
              }
              return _buildSearchHistory();
            },
          ),
        ),
      ],
    );
  }

  // New movie grid with custom card design
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

  Widget _buildSearchHistory() {
    final searchHistory = context.read<SearchLocalSource>().getSearchHistory();
    if (searchHistory.isEmpty) {
      return const EmptyState(
        message: 'Search for movies',
        icon: Icons.search,
      );
    }

    // Use ListView.builder with proper padding
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth > 600 ? 16.0 : 8.0;

    return ListView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        final query = searchHistory[index];
        return ListTile(
          dense: screenWidth < 360, // More compact on very small screens
          leading: const Icon(Icons.history),
          title: Text(
            query,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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

// New responsive movie card with modern design
class ResponsiveMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const ResponsiveMovieCard({
    Key? key,
    required this.movie,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Responsive dimensions
    final cardWidth = 160.w;
    final cardHeight = 240.h;
    final borderRadius = 12.r;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              // Poster image
              Positioned.fill(
                child: movie.poster.isNotEmpty
                    ? Image.network(
                  movie.poster,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: Icon(Icons.movie, size: 50.sp, color: Colors.white54),
                  ),
                )
                    : Container(
                  color: Colors.grey[800],
                  child: Icon(Icons.movie, size: 50.sp, color: Colors.white54),
                ),
              ),
              // Gradient overlay for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Movie info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Year and rating
                      Row(
                        children: [
                          if (movie.imdbRating != null) ...[
                            Icon(Icons.star, size: 14.sp, color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(
                              movie.imdbRating!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                          Icon(Icons.calendar_today, size: 14.sp, color: Colors.white70),
                          SizedBox(width: 4.w),
                          Text(
                            movie.year,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      // Type badge (movie/tv show)
                      if (movie.type != null) ...[
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            movie.type!.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}