import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bulk_action_menu_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/pattern_card_widget.dart';
import './widgets/search_bar_widget.dart';

class PatternLibrary extends StatefulWidget {
  const PatternLibrary({Key? key}) : super(key: key);

  @override
  State<PatternLibrary> createState() => _PatternLibraryState();
}

class _PatternLibraryState extends State<PatternLibrary>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  // State variables
  String _searchQuery = '';
  String _sortBy = 'recent';
  Map<String, dynamic> _filters = {};
  Set<String> _selectedPatterns = {};
  bool _isSelectionMode = false;
  bool _isRefreshing = false;
  Map<String, bool> _cardActions = {};

  // Mock data for patterns
  final List<Map<String, dynamic>> _allPatterns = [
    {
      'id': '1',
      'title': 'Elegant Evening Dress',
      'garmentType': 'Dress',
      'fabricType': 'Silk',
      'status': 'Completed',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      'thumbnail':
          'https://images.unsplash.com/photo-1566479179817-c0b2b2b6b6b6?w=400&h=600&fit=crop',
      'syncStatus': 'synced',
    },
    {
      'id': '2',
      'title': 'Casual Cotton Shirt',
      'garmentType': 'Shirt',
      'fabricType': 'Cotton',
      'status': 'In Progress',
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
      'thumbnail':
          'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=400&h=600&fit=crop',
      'syncStatus': 'offline',
    },
    {
      'id': '3',
      'title': 'Traditional Saree Jacket',
      'garmentType': 'Saree Jacket',
      'fabricType': 'Silk',
      'status': 'Completed',
      'createdAt': DateTime.now().subtract(const Duration(days: 7)),
      'thumbnail':
          'https://images.unsplash.com/photo-1583391733956-6c78276477e2?w=400&h=600&fit=crop',
      'syncStatus': 'synced',
    },
    {
      'id': '4',
      'title': 'Summer T-Shirt Design',
      'garmentType': 'T-shirt',
      'fabricType': 'Cotton',
      'status': 'Draft',
      'createdAt': DateTime.now().subtract(const Duration(days: 10)),
      'thumbnail':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=600&fit=crop',
      'syncStatus': 'synced',
    },
    {
      'id': '5',
      'title': 'Formal Blazer Pattern',
      'garmentType': 'Shirt',
      'fabricType': 'Wool',
      'status': 'Completed',
      'createdAt': DateTime.now().subtract(const Duration(days: 15)),
      'thumbnail':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop',
      'syncStatus': 'synced',
    },
    {
      'id': '6',
      'title': 'Flowy Chiffon Blouse',
      'garmentType': 'Blouse',
      'fabricType': 'Chiffon',
      'status': 'In Progress',
      'createdAt': DateTime.now().subtract(const Duration(days: 20)),
      'thumbnail':
          'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400&h=600&fit=crop',
      'syncStatus': 'offline',
    },
  ];

  List<Map<String, dynamic>> _filteredPatterns = [];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _refreshController, curve: Curves.easeInOut),
    );
    _filteredPatterns = List.from(_allPatterns);
    _applyFiltersAndSort();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Search and filter bar
                SearchBarWidget(
                  initialValue: _searchQuery,
                  onSearchChanged: _onSearchChanged,
                  onFilterTap: _showFilterBottomSheet,
                  sortValue: _sortBy,
                  onSortChanged: _onSortChanged,
                ),
                // Main content
                Expanded(
                  child: _filteredPatterns.isEmpty
                      ? _searchQuery.isNotEmpty || _filters.isNotEmpty
                          ? _buildNoResultsState()
                          : EmptyStateWidget(
                              onCreateDesign: () => Navigator.pushNamed(
                                  context, '/home-dashboard'),
                            )
                      : _buildPatternGrid(),
                ),
              ],
            ),
            // Bulk action menu
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BulkActionMenuWidget(
                selectedCount: _selectedPatterns.length,
                onExportSelected: _exportSelectedPatterns,
                onDuplicateSelected: _duplicateSelectedPatterns,
                onDeleteSelected: _deleteSelectedPatterns,
                onDeselectAll: _exitSelectionMode,
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation would be handled by parent widget
    );
  }

  Widget _buildPatternGrid() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.accent,
      backgroundColor: AppTheme.surface,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(4.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 4.w,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final pattern = _filteredPatterns[index];
                  final patternId = pattern['id'] as String;
                  final isSelected = _selectedPatterns.contains(patternId);
                  final showActions = _cardActions[patternId] ?? false;

                  return PatternCardWidget(
                    pattern: pattern,
                    isSelected: isSelected,
                    showActions: showActions,
                    onTap: () => _onPatternTap(patternId),
                    onLongPress: () => _onPatternLongPress(patternId),
                    onEdit: () => _editPattern(patternId),
                    onDuplicate: () => _duplicatePattern(patternId),
                    onExport: () => _exportPattern(patternId),
                    onDelete: () => _deletePattern(patternId),
                  );
                },
                childCount: _filteredPatterns.length,
              ),
            ),
          ),
          // Bottom padding for bulk action menu
          SliverPadding(
            padding: EdgeInsets.only(
                bottom: _selectedPatterns.isNotEmpty ? 16.h : 0),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.disabled,
              size: 20.w,
            ),
            SizedBox(height: 4.h),
            Text(
              'No Results Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Try adjusting your search or filters to find what you\'re looking for.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            TextButton(
              onPressed: _clearSearchAndFilters,
              child: Text(
                'Clear Search & Filters',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFiltersAndSort();
  }

  void _onSortChanged(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
    _applyFiltersAndSort();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _filters,
        onFiltersChanged: (filters) {
          setState(() {
            _filters = filters;
          });
          _applyFiltersAndSort();
        },
      ),
    );
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_allPatterns);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((pattern) {
        final title = (pattern['title'] as String? ?? '').toLowerCase();
        final garmentType =
            (pattern['garmentType'] as String? ?? '').toLowerCase();
        final fabricType =
            (pattern['fabricType'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            garmentType.contains(query) ||
            fabricType.contains(query);
      }).toList();
    }

    // Apply filters
    if (_filters['garmentType'] != null) {
      filtered = filtered
          .where((pattern) => pattern['garmentType'] == _filters['garmentType'])
          .toList();
    }

    if (_filters['fabricType'] != null) {
      filtered = filtered
          .where((pattern) => pattern['fabricType'] == _filters['fabricType'])
          .toList();
    }

    if (_filters['status'] != null) {
      filtered = filtered
          .where((pattern) => pattern['status'] == _filters['status'])
          .toList();
    }

    if (_filters['startDate'] != null) {
      filtered = filtered.where((pattern) {
        final createdAt = pattern['createdAt'] as DateTime?;
        return createdAt != null &&
            createdAt.isAfter(_filters['startDate'] as DateTime);
      }).toList();
    }

    if (_filters['endDate'] != null) {
      filtered = filtered.where((pattern) {
        final createdAt = pattern['createdAt'] as DateTime?;
        return createdAt != null &&
            createdAt.isBefore(_filters['endDate'] as DateTime);
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'recent':
        filtered.sort((a, b) {
          final aDate = a['createdAt'] as DateTime? ?? DateTime.now();
          final bDate = b['createdAt'] as DateTime? ?? DateTime.now();
          return bDate.compareTo(aDate);
        });
        break;
      case 'alphabetical':
        filtered.sort((a, b) {
          final aTitle = a['title'] as String? ?? '';
          final bTitle = b['title'] as String? ?? '';
          return aTitle.compareTo(bTitle);
        });
        break;
      case 'mostUsed':
        // Mock implementation - in real app, this would use usage data
        filtered.shuffle();
        break;
      case 'dateCreated':
        filtered.sort((a, b) {
          final aDate = a['createdAt'] as DateTime? ?? DateTime.now();
          final bDate = b['createdAt'] as DateTime? ?? DateTime.now();
          return aDate.compareTo(bDate);
        });
        break;
    }

    setState(() {
      _filteredPatterns = filtered;
    });
  }

  void _clearSearchAndFilters() {
    setState(() {
      _searchQuery = '';
      _filters.clear();
    });
    _applyFiltersAndSort();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 2));

    // In real app, this would sync with cloud storage
    setState(() {
      _isRefreshing = false;
    });

    _refreshController.reset();
    _applyFiltersAndSort();
  }

  void _onPatternTap(String patternId) {
    if (_isSelectionMode) {
      _togglePatternSelection(patternId);
    } else {
      // Hide any visible actions first
      setState(() {
        _cardActions.clear();
      });
      // Navigate to pattern preview
      Navigator.pushNamed(context, '/pattern-preview', arguments: patternId);
    }
  }

  void _onPatternLongPress(String patternId) {
    if (!_isSelectionMode) {
      setState(() {
        _cardActions[patternId] = !(_cardActions[patternId] ?? false);
        // Hide other card actions
        _cardActions.forEach((key, value) {
          if (key != patternId) {
            _cardActions[key] = false;
          }
        });
      });

      // Auto-hide after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _cardActions[patternId] = false;
          });
        }
      });
    } else {
      _togglePatternSelection(patternId);
    }
  }

  void _togglePatternSelection(String patternId) {
    setState(() {
      if (_selectedPatterns.contains(patternId)) {
        _selectedPatterns.remove(patternId);
        if (_selectedPatterns.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedPatterns.add(patternId);
        _isSelectionMode = true;
      }
      // Hide card actions when in selection mode
      _cardActions.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectedPatterns.clear();
      _isSelectionMode = false;
    });
  }

  void _editPattern(String patternId) {
    setState(() {
      _cardActions[patternId] = false;
    });
    Navigator.pushNamed(context, '/design-customization', arguments: patternId);
  }

  void _duplicatePattern(String patternId) {
    setState(() {
      _cardActions[patternId] = false;
    });

    // Find the pattern to duplicate
    final pattern = _allPatterns.firstWhere((p) => p['id'] == patternId);
    final duplicatedPattern = Map<String, dynamic>.from(pattern);
    duplicatedPattern['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    duplicatedPattern['title'] = '${pattern['title']} (Copy)';
    duplicatedPattern['createdAt'] = DateTime.now();

    setState(() {
      _allPatterns.insert(0, duplicatedPattern);
    });
    _applyFiltersAndSort();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pattern duplicated successfully'),
        backgroundColor: AppTheme.accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportPattern(String patternId) {
    setState(() {
      _cardActions[patternId] = false;
    });

    // Mock export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting pattern...'),
        backgroundColor: AppTheme.accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deletePattern(String patternId) {
    setState(() {
      _cardActions[patternId] = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Delete Pattern',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
        ),
        content: Text(
          'Are you sure you want to delete this pattern? This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allPatterns.removeWhere((p) => p['id'] == patternId);
              });
              _applyFiltersAndSort();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pattern deleted'),
                  backgroundColor: AppTheme.alert,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.alert,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportSelectedPatterns() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${_selectedPatterns.length} patterns...'),
        backgroundColor: AppTheme.accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
    _exitSelectionMode();
  }

  void _duplicateSelectedPatterns() {
    final selectedPatterns =
        _allPatterns.where((p) => _selectedPatterns.contains(p['id'])).toList();

    for (final pattern in selectedPatterns) {
      final duplicatedPattern = Map<String, dynamic>.from(pattern);
      duplicatedPattern['id'] =
          DateTime.now().millisecondsSinceEpoch.toString() +
              selectedPatterns.indexOf(pattern).toString();
      duplicatedPattern['title'] = '${pattern['title']} (Copy)';
      duplicatedPattern['createdAt'] = DateTime.now();
      _allPatterns.insert(0, duplicatedPattern);
    }

    _applyFiltersAndSort();
    _exitSelectionMode();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selectedPatterns.length} patterns duplicated'),
        backgroundColor: AppTheme.accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteSelectedPatterns() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Delete Patterns',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
        ),
        content: Text(
          'Are you sure you want to delete ${_selectedPatterns.length} patterns? This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allPatterns
                    .removeWhere((p) => _selectedPatterns.contains(p['id']));
              });
              final deletedCount = _selectedPatterns.length;
              _exitSelectionMode();
              _applyFiltersAndSort();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$deletedCount patterns deleted'),
                  backgroundColor: AppTheme.alert,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.alert,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
