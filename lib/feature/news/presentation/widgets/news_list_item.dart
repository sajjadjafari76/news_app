import 'package:flutter/material.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

/// Widget for displaying individual news items
/// Follows Single Responsibility Principle (SRP)
class NewsListItem extends StatelessWidget {
  final NewsEntity news;
  final String companyName;
  final String formattedDate;

  const NewsListItem({
    super.key,
    required this.news,
    required this.companyName,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company name and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCompanyColor(companyName),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    companyName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // News image
            if (news.urlToImage != null && news.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  news.urlToImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),

            // News title
            Text(
              news.title ?? 'No title',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // News description
            Text(
              news.description ?? 'No description available',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Author
            if (news.author != null && news.author!.isNotEmpty)
              Text(
                'By ${news.author}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getCompanyColor(String company) {
    switch (company.toLowerCase()) {
      case 'microsoft':
        return Colors.blue;
      case 'apple':
        return Colors.grey[800]!;
      case 'google':
        return Colors.red;
      case 'tesla':
        return Colors.grey[600]!;
      default:
        return Colors.grey;
    }
  }
}
