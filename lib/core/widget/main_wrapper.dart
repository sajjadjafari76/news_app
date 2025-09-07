import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/core/routes/app_routes.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

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
