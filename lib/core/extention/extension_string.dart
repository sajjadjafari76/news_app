extension StringExtension on String {
  /// Gets the company name from a news title.
  String getCompanyName() {
    final lowerTitle = toLowerCase();
    if (lowerTitle.contains('microsoft')) return 'Microsoft';
    if (lowerTitle.contains('apple')) return 'Apple';
    if (lowerTitle.contains('google')) return 'Google';
    if (lowerTitle.contains('tesla')) return 'Tesla';
    // Add new companies here in the future
    return 'Unknown';
  }
}
