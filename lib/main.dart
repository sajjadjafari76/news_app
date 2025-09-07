import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/widget/main_wrapper.dart';
import 'feature/news/data/models/news_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  await _initializeHiveDatabase();

  runApp(const AppWrapper());
}

Future<void> _initializeHiveDatabase() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NewsModelAdapter());
  await Hive.openBox<List<dynamic>>('news_list_cache_box');
}
