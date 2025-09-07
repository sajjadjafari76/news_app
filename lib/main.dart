import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/routes/app_routes.dart';

void main() async {
  /*
  You only need to call this method if you need the binding to be
  initialized before calling [runApp].
  */
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  // init the GetStorage
  await GetStorage.init();

  // initialize Hive database

  await Hive.initFlutter();
  // Hive.registerAdapter(CityModelBaseAdapter());
  await Hive.openBox('news');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News App',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.newsList,
      // initialBinding: NewsBindings(),
    );
  }
}
