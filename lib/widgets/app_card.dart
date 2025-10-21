import 'package:flutter/material.dart';
import '../models/app_idea.dart';

class AppCard extends StatelessWidget {
  final AppIdea appIdea;
  final VoidCallback onTap;

  const AppCard({
    Key? key,
    required this.appIdea,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Icon Placeholder
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(appIdea.category),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Icon(
                        _getCategoryIcon(appIdea.category),
                        color: Colors.white,
                        size: 32.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),

                  // App Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appIdea.appName,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          appIdea.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // Categories and Tags
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildTag(
                      appIdea.category, _getCategoryColor(appIdea.category)),
                  _buildTag(appIdea.targetAudience, Colors.green),
                  _buildTag(appIdea.platform, Colors.purple),
                  _buildTag(appIdea.pricingRange, Colors.orange),
                ],
              ),

              const SizedBox(height: 16.0),

              // Key Metrics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetric(
                    'Revenue',
                    appIdea.monthlyRevenue > 0
                        ? '\$${_formatRevenue(appIdea.monthlyRevenue)}'
                        : 'N/A',
                    Icons.attach_money,
                  ),
                  _buildMetric(
                    'Users',
                    appIdea.monthlyUsers > 0
                        ? '${_formatUsers(appIdea.monthlyUsers)}'
                        : 'N/A',
                    Icons.people,
                  ),
                  _buildMetric(
                    'CAC',
                    appIdea.customerAcquisitionCost > 0
                        ? '\$${appIdea.customerAcquisitionCost}'
                        : 'N/A',
                    Icons.shopping_cart,
                  ),
                  _buildMetric(
                    'Team',
                    appIdea.teamSize > 0 ? '${appIdea.teamSize}' : 'N/A',
                    Icons.group,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 20.0,
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'productivity':
        return Colors.blue;
      case 'lead gen':
        return Colors.green;
      case 'sales':
        return Colors.orange;
      case 'marketing':
        return Colors.purple;
      case 'content':
        return Colors.teal;
      case 'education':
        return Colors.amber;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'productivity':
        return Icons.work;
      case 'lead gen':
        return Icons.person_add;
      case 'sales':
        return Icons.shopping_cart;
      case 'marketing':
        return Icons.campaign;
      case 'content':
        return Icons.article;
      case 'education':
        return Icons.school;
      default:
        return Icons.app_shortcut;
    }
  }

  String _formatRevenue(double revenue) {
    if (revenue >= 1000000) {
      return '${(revenue / 1000000).toStringAsFixed(1)}M';
    } else if (revenue >= 1000) {
      return '${(revenue / 1000).toStringAsFixed(1)}K';
    } else {
      return revenue.toString();
    }
  }

  String _formatUsers(int users) {
    if (users >= 1000000) {
      return '${(users / 1000000).toStringAsFixed(1)}M';
    } else if (users >= 1000) {
      return '${(users / 1000).toStringAsFixed(1)}K';
    } else {
      return users.toString();
    }
  }
}
