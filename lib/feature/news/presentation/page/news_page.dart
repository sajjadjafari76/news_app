import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/core/extention/extension_date_time.dart';
import 'package:interview/core/extention/extension_string.dart';

import '../controller/news_controller.dart';
import '../widgets/news_list_item.dart';

/// Main news page displaying all companies news
/// Follows Single Responsibility Principle (SRP)
class NewsPage extends GetView<NewsController> {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech News'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: controller.refreshNews)],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: controller.refreshNews, child: const Text('Retry')),
              ],
            ),
          );
        }

        if (controller.newsList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No news available', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNews,
          child: Column(
            children: [
              // Last updated info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Text(
                  'Last updated: ${controller.lastUpdated.value.formatDate()}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),

              // News list
              Expanded(
                child: ListView.builder(
                  itemCount: controller.newsList.length,
                  itemBuilder: (context, index) {
                    final news = controller.newsList[index];
                    final companyName = news.title?.getCompanyName() ?? "";
                    final formattedDate = news.publishedAt?.formatDate() ?? '';

                    return NewsListItem(news: news, companyName: companyName, formattedDate: formattedDate);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
