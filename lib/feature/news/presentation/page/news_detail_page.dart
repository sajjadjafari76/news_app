import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/core/extention/extension_date_time.dart';
import 'package:interview/core/extention/extension_string.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

import '../controller/news_detail_controller.dart';

/// News detail page displaying full article content
class NewsDetailPage extends GetView<NewsDetailController> {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Obx(() {
        final news = controller.news.value;

        if (news == null) {
          return _errorShowing();
        }

        return _mainInfo(news);
      }),
    );
  }

  Widget _mainInfo(NewsEntity news) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company tag and date
          _buildHeader(news),
          const SizedBox(height: 16),

          // Article title
          _buildTitle(news),
          const SizedBox(height: 16),

          // Article image
          _buildImage(news),
          const SizedBox(height: 16),

          // Author and source info
          _buildAuthorAndSource(news),
          const SizedBox(height: 16),

          // Full date
          _buildFullDate(news),
          const SizedBox(height: 20),

          // Article description
          _buildDescription(news),
          const SizedBox(height: 20),

          // Article content
          _buildContent(news),
          const SizedBox(height: 20),

          // Read more button
          _buildReadMoreButton(news),
        ],
      ),
    );
  }

  Center _errorShowing() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No article data available', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Article Details'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
    );
  }

  Widget _buildHeader(NewsEntity news) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getCompanyColor(news.title?.getCompanyName() ?? ""),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            news.title?.getCompanyName() ?? "",
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Text(news.publishedAt?.formatDate() ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildTitle(NewsEntity news) {
    return Text(
      news.title ?? 'No title available',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
    );
  }

  Widget _buildImage(NewsEntity news) {
    if (news.urlToImage != null && news.urlToImage!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          news.urlToImage ?? '',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 250,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey)),
            );
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildAuthorAndSource(NewsEntity news) {
    return Row(
      children: [
        if (news.author != null && news.author!.isNotEmpty) ...[
          const Icon(Icons.person, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              news.author ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
        ],
        const Spacer(),
        const Icon(Icons.public, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          controller.getSource(news),
          style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildFullDate(NewsEntity news) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          news.publishedAt?.formatFullDate() ?? 'unknown date',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDescription(news) {
    if (news.description != null && news.description!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(news.description ?? '', style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildContent(NewsEntity news) {
    if (news.content != null && news.content!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Full Article', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(news.content ?? '', style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildReadMoreButton(NewsEntity news) {
    if (news.url != null && news.url!.isNotEmpty) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => controller.lunchReadMorePage(Uri.parse(news.url ?? '')),
          icon: const Icon(Icons.open_in_new),
          label: const Text('Read Full Article'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
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
