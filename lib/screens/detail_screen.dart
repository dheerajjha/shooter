import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_idea.dart';

class DetailScreen extends StatelessWidget {
  final AppIdea appIdea;

  const DetailScreen({Key? key, required this.appIdea}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appIdea.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () => _launchUrl(appIdea.appUrl),
            tooltip: 'Visit website',
          ),
          if (appIdea.caseStudyLink.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.article),
              onPressed: () => _launchUrl(appIdea.caseStudyLink),
              tooltip: 'Read case study',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Overview Card
            _buildOverviewCard(context),
            const SizedBox(height: 24.0),
            
            // Business Model
            _buildSectionTitle('Business Model'),
            _buildInfoRow('Category', appIdea.category),
            _buildInfoRow('Business Type', appIdea.businessModel),
            _buildInfoRow('Platform', appIdea.platform),
            _buildInfoRow('Target Audience', appIdea.targetAudience),
            const SizedBox(height: 24.0),
            
            // Pricing & Revenue
            _buildSectionTitle('Pricing & Revenue'),
            _buildInfoRow('Price Range', appIdea.pricingRange),
            _buildInfoRow('Monetization', appIdea.monetizationModel),
            _buildInfoRow('Free Version', appIdea.hasFreeVersion ? 'Yes' : 'No'),
            _buildInfoRow('Pricing Details', appIdea.pricingDetails),
            if (appIdea.monthlyRevenue > 0)
              _buildInfoRow('Monthly Revenue', '\$${appIdea.monthlyRevenue}'),
            if (appIdea.monthlyUsers > 0)
              _buildInfoRow('Monthly Users', appIdea.monthlyUsers.toString()),
            if (appIdea.customerAcquisitionCost > 0)
              _buildInfoRow('Acquisition Cost', '\$${appIdea.customerAcquisitionCost}'),
            const SizedBox(height: 24.0),
            
            // Development
            _buildSectionTitle('Development'),
            _buildInfoRow('Team Size', appIdea.teamSize.toString()),
            _buildInfoRow('Launch Year', appIdea.launchYear),
            _buildInfoRow('Development Time', appIdea.developmentTime),
            if (appIdea.techStack.isNotEmpty)
              _buildInfoRow('Tech Stack', appIdea.techStack),
            const SizedBox(height: 24.0),
            
            // Marketing & Growth
            _buildSectionTitle('Marketing & Growth'),
            if (appIdea.searchTrend.isNotEmpty)
              _buildInfoRow('Search Trend', appIdea.searchTrend),
            if (appIdea.competitor.isNotEmpty)
              _buildInfoRow('Key Competitor', appIdea.competitor),
            if (appIdea.marketingStrategy.isNotEmpty)
              _buildInfoRow('Marketing Strategy', appIdea.marketingStrategy, isMultiLine: true),
            if (appIdea.marketingChannel.isNotEmpty)
              _buildInfoRow('Marketing Channel', appIdea.marketingChannel),
            if (appIdea.acquisitionStrategy.isNotEmpty)
              _buildInfoRow('Acquisition Strategy', appIdea.acquisitionStrategy),
            const SizedBox(height: 24.0),
            
            // Founder Story
            if (appIdea.founderStory.isNotEmpty) ...[
              _buildSectionTitle('Founder Story'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  appIdea.founderStory,
                  style: const TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
            
            // Development Process
            if (appIdea.developmentProcess.isNotEmpty) ...[
              _buildSectionTitle('Development Process'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  appIdea.developmentProcess,
                  style: const TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
            
            // Links and Resources
            _buildSectionTitle('Links & Resources'),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Official Website'),
              subtitle: Text(appIdea.appUrl),
              onTap: () => _launchUrl(appIdea.appUrl),
            ),
            if (appIdea.caseStudyLink.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text('Case Study'),
                subtitle: Text(appIdea.caseStudyLink),
                onTap: () => _launchUrl(appIdea.caseStudyLink),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appIdea.appName,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              appIdea.description,
              style: const TextStyle(
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              children: [
                _buildChip(appIdea.category, Colors.blue),
                _buildChip(appIdea.targetAudience, Colors.green),
                _buildChip(appIdea.platform, Colors.purple),
                _buildChip(appIdea.monetizationModel, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120.0,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
} 