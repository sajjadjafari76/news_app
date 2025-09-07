import 'package:get/get.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';
import 'package:url_launcher/url_launcher.dart';

/// Controller for managing news detail display
/// Follows Single Responsibility Principle (SRP)
class NewsDetailController extends GetxController {
  // Observable state
  var news = Rxn<NewsEntity>();

  @override
  void onInit() {
    super.onInit();
    _loadNewsFromArguments();
  }

  /// Loads news data from route arguments
  void _loadNewsFromArguments() {
    final arguments = Get.arguments;
    if (arguments != null && arguments is NewsEntity) {
      news.value = arguments;
    }
  }

  /// lunch read more page
  void lunchReadMorePage(Uri? url) async {
    if (url == null) {
      return;
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }


  /// Gets the source from the URL
  String getSource(NewsEntity news) {
    if (news.url == null || news.url!.isEmpty) return 'Unknown Source';

    try {
      final uri = Uri.parse(news.url!);
      return uri.host.replaceAll('www.', '');
    } catch (e) {
      return 'Unknown Source';
    }
  }
}
