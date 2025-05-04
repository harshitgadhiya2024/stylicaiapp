import 'package:flutter/material.dart';
import 'package:stylicai/Utills/globle_variable.dart';
import 'package:stylicai/Utills/photoshoot_service.dart';
import '../Model/photoshoot.dart';
import '../widgets/filter_section.dart';
import '../widgets/photoshoot_card.dart';
import 'photoshoot_detail_screen.dart';

class PhotoshootListScreen extends StatefulWidget {
  const PhotoshootListScreen({Key? key}) : super(key: key);

  @override
  _PhotoshootListScreenState createState() => _PhotoshootListScreenState();
}

class _PhotoshootListScreenState extends State<PhotoshootListScreen> {
  final PhotoshootService _service = PhotoshootService();
  List<Photoshoot> _allPhotoshoots = [];
  List<Photoshoot> _filteredPhotoshoots = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  String? _selectedCompletionFilter;
  String? _selectedGarmentType;
  Set<String> _garmentTypes = {};

  @override
  void initState() {
    super.initState();
    _fetchPhotoshoots();
  }

  Future<void> _fetchPhotoshoots() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Replace with actual user ID or retrieve it from secure storage
      final userId = GlobleVariables.userId;
      final photoshoots = await _service.getAllPhotoshoots(userId);

      setState(() {
        _allPhotoshoots = photoshoots;
        _filteredPhotoshoots = photoshoots;

        // Extract all unique garment types for filtering
        _garmentTypes = photoshoots
            .map((p) => p.garmentType)
            .where((type) => type.isNotEmpty)
            .toSet();
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredPhotoshoots = _allPhotoshoots.where((photoshoot) {
        // Apply completion filter if selected
        if (_selectedCompletionFilter != null) {
          bool isCompleted = _selectedCompletionFilter == 'Completed';
          if (photoshoot.isCompleted != isCompleted) {
            return false;
          }
        }

        // Apply garment type filter if selected
        if (_selectedGarmentType != null &&
            _selectedGarmentType != 'All' &&
            photoshoot.garmentType != _selectedGarmentType) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCompletionFilter = null;
      _selectedGarmentType = null;
      _filteredPhotoshoots = _allPhotoshoots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? _buildErrorView()
          : _buildContentView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load photoshoots',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchPhotoshoots,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        children: [
          FilterSection(
            selectedCompletionFilter: _selectedCompletionFilter,
            selectedGarmentType: _selectedGarmentType,
            garmentTypes: _garmentTypes,
            onCompletionFilterChanged: (value) {
              setState(() {
                _selectedCompletionFilter = value;
                _applyFilters();
              });
            },
            onGarmentTypeChanged: (value) {
              setState(() {
                _selectedGarmentType = value;
                _applyFilters();
              });
            },
            onResetFilters: _resetFilters,
          ),
          Expanded(
            child: _filteredPhotoshoots.isEmpty
                ? _buildEmptyView()
                : _buildPhotoshootGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No photoshoots found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          if (_selectedCompletionFilter != null || _selectedGarmentType != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _resetFilters,
              child: const Text('Clear filters and try again'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoshootGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredPhotoshoots.length,
      itemBuilder: (context, index) {
        final photoshoot = _filteredPhotoshoots[index];
        return PhotoshootCard(
          photoshoot: photoshoot,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoshootDetailScreen(photoshoot: photoshoot),
              ),
            );
          },
        );
      },
    );
  }
}