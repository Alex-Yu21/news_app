enum NewsCategory {
  business,
  entertainment,
  general,
  health,
  science,
  sports,
  technology,
}

extension NewsCategoryX on NewsCategory {
  String get api {
    switch (this) {
      case NewsCategory.business:
        return 'business';
      case NewsCategory.entertainment:
        return 'entertainment';
      case NewsCategory.general:
        return 'general';
      case NewsCategory.health:
        return 'health';
      case NewsCategory.science:
        return 'science';
      case NewsCategory.sports:
        return 'sports';
      case NewsCategory.technology:
        return 'technology';
    }
  }

  static NewsCategory? fromApi(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    switch (value.toLowerCase()) {
      case 'business':
        return NewsCategory.business;
      case 'entertainment':
        return NewsCategory.entertainment;
      case 'general':
        return NewsCategory.general;
      case 'health':
        return NewsCategory.health;
      case 'science':
        return NewsCategory.science;
      case 'sports':
        return NewsCategory.sports;
      case 'technology':
        return NewsCategory.technology;
      default:
        return null;
    }
  }
}
