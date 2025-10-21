class AppIdea {
  final String appName;
  final String appUrl;
  final String description;
  final String category;
  final String businessModel;
  final String platform;
  final String targetAudience;
  final String pricingRange;
  final String monetizationModel;
  final bool hasFreeVersion;
  final String pricingDetails;
  final double monthlyRevenue;
  final int monthlyUsers;
  final double customerAcquisitionCost;
  final int teamSize;
  final String launchYear;
  final String developmentTime;
  final String searchTrend;
  final String competitor;
  final String founderStory;
  final String developmentProcess;
  final String marketingStrategy;
  final String marketingChannel;
  final String acquisitionStrategy;
  final String techStack;
  final String caseStudyLink;

  AppIdea({
    required this.appName,
    required this.appUrl,
    required this.description,
    required this.category,
    required this.businessModel,
    required this.platform,
    required this.targetAudience,
    required this.pricingRange,
    required this.monetizationModel,
    required this.hasFreeVersion,
    required this.pricingDetails,
    required this.monthlyRevenue,
    required this.monthlyUsers,
    required this.customerAcquisitionCost,
    required this.teamSize,
    required this.launchYear,
    required this.developmentTime,
    required this.searchTrend,
    required this.competitor,
    required this.founderStory,
    required this.developmentProcess,
    required this.marketingStrategy,
    required this.marketingChannel,
    required this.acquisitionStrategy,
    required this.techStack,
    required this.caseStudyLink,
  });

  // Factory method to create AppIdea from json
  factory AppIdea.fromJson(Map<String, dynamic> json) {
    return AppIdea(
      appName: json['appName'] ?? '',
      appUrl: json['appUrl'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      businessModel: json['businessModel'] ?? '',
      platform: json['platform'] ?? '',
      targetAudience: json['targetAudience'] ?? '',
      pricingRange: json['pricingRange'] ?? '',
      monetizationModel: json['monetizationModel'] ?? '',
      hasFreeVersion: json['hasFreeVersion'] ?? false,
      pricingDetails: json['pricingDetails'] ?? '',
      monthlyRevenue: json['monthlyRevenue']?.toDouble() ?? 0.0,
      monthlyUsers: json['monthlyUsers'] ?? 0,
      customerAcquisitionCost:
          json['customerAcquisitionCost']?.toDouble() ?? 0.0,
      teamSize: json['teamSize'] ?? 0,
      launchYear: json['launchYear'] ?? '',
      developmentTime: json['developmentTime'] ?? '',
      searchTrend: json['searchTrend'] ?? '',
      competitor: json['competitor'] ?? '',
      founderStory: json['founderStory'] ?? '',
      developmentProcess: json['developmentProcess'] ?? '',
      marketingStrategy: json['marketingStrategy'] ?? '',
      marketingChannel: json['marketingChannel'] ?? '',
      acquisitionStrategy: json['acquisitionStrategy'] ?? '',
      techStack: json['techStack'] ?? '',
      caseStudyLink: json['caseStudyLink'] ?? '',
    );
  }

  // Method to convert AppIdea to json
  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'appUrl': appUrl,
      'description': description,
      'category': category,
      'businessModel': businessModel,
      'platform': platform,
      'targetAudience': targetAudience,
      'pricingRange': pricingRange,
      'monetizationModel': monetizationModel,
      'hasFreeVersion': hasFreeVersion,
      'pricingDetails': pricingDetails,
      'monthlyRevenue': monthlyRevenue,
      'monthlyUsers': monthlyUsers,
      'customerAcquisitionCost': customerAcquisitionCost,
      'teamSize': teamSize,
      'launchYear': launchYear,
      'developmentTime': developmentTime,
      'searchTrend': searchTrend,
      'competitor': competitor,
      'founderStory': founderStory,
      'developmentProcess': developmentProcess,
      'marketingStrategy': marketingStrategy,
      'marketingChannel': marketingChannel,
      'acquisitionStrategy': acquisitionStrategy,
      'techStack': techStack,
      'caseStudyLink': caseStudyLink,
    };
  }
}
