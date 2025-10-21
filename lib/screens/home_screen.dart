import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_idea.dart';
import '../services/app_data_service.dart';
import '../widgets/app_card.dart';
import '../widgets/filter_bar.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppDataService _dataService = AppDataService();
  List<AppIdea> _appIdeas = [];
  List<AppIdea> _filteredAppIdeas = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedPriceRange = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _dataService.getAppIdeas();
      setState(() {
        _appIdeas = data;
        _filteredAppIdeas = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  void _filterAppIdeas() {
    setState(() {
      _filteredAppIdeas = _appIdeas.where((app) {
        // Apply search filter
        final matchesSearch = _searchQuery.isEmpty ||
            app.appName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            app.description.toLowerCase().contains(_searchQuery.toLowerCase());

        // Apply category filter
        final matchesCategory =
            _selectedCategory == 'All' || app.category == _selectedCategory;

        // Apply price range filter
        final matchesPriceRange = _selectedPriceRange == 'All' ||
            app.pricingRange.contains(_selectedPriceRange);

        return matchesSearch && matchesCategory && matchesPriceRange;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterAppIdeas();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterAppIdeas();
  }

  void _onPriceRangeSelected(String priceRange) {
    setState(() {
      _selectedPriceRange = priceRange;
    });
    _filterAppIdeas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI App Ideas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show information dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: const Text(
                    'This app showcases 50+ AI app ideas that are generating millions in revenue. Data sourced from Starter Story.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search AI app ideas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Filter Bar
          FilterBar(
            selectedCategory: _selectedCategory,
            selectedPriceRange: _selectedPriceRange,
            onCategorySelected: _onCategorySelected,
            onPriceRangeSelected: _onPriceRangeSelected,
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Showing ${_filteredAppIdeas.length} results',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: _loadData,
                ),
              ],
            ),
          ),

          // App Ideas List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAppIdeas.isEmpty
                    ? const Center(
                        child: Text(
                          'No app ideas match your filters',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _filteredAppIdeas.length,
                        itemBuilder: (context, index) {
                          final app = _filteredAppIdeas[index];
                          return AppCard(
                            appIdea: app,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(appIdea: app),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
