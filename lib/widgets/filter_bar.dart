import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String selectedCategory;
  final String selectedPriceRange;
  final Function(String) onCategorySelected;
  final Function(String) onPriceRangeSelected;

  const FilterBar({
    Key? key,
    required this.selectedCategory,
    required this.selectedPriceRange,
    required this.onCategorySelected,
    required this.onPriceRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          child: Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              _buildCategoryChip(context, 'All', selectedCategory == 'All'),
              _buildCategoryChip(
                  context, 'Productivity', selectedCategory == 'Productivity'),
              _buildCategoryChip(
                  context, 'Lead Gen', selectedCategory == 'Lead Gen'),
              _buildCategoryChip(context, 'Sales', selectedCategory == 'Sales'),
              _buildCategoryChip(
                  context, 'Marketing', selectedCategory == 'Marketing'),
              _buildCategoryChip(
                  context, 'Content', selectedCategory == 'Content'),
              _buildCategoryChip(
                  context, 'Education', selectedCategory == 'Education'),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          child: Text(
            'Price Range',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              _buildPriceRangeChip(context, 'All', selectedPriceRange == 'All'),
              _buildPriceRangeChip(
                  context, 'Free', selectedPriceRange == 'Free'),
              _buildPriceRangeChip(
                  context, '\$1 - \$49', selectedPriceRange == '\$1 - \$49'),
              _buildPriceRangeChip(
                  context, '\$49 - \$99', selectedPriceRange == '\$49 - \$99'),
              _buildPriceRangeChip(context, '\$99 - \$199',
                  selectedPriceRange == '\$99 - \$199'),
              _buildPriceRangeChip(
                  context, '\$199+', selectedPriceRange == '\$199+'),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildCategoryChip(
      BuildContext context, String category, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            onCategorySelected(category);
          }
        },
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPriceRangeChip(
      BuildContext context, String priceRange, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(priceRange),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            onPriceRangeSelected(priceRange);
          }
        },
        selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
