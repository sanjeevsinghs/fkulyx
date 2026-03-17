import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/routes/app_pages.dart';
import 'package:kulyx/routes/app_routes.dart';

void main() {
  runApp(const Kulyx());
}

class Kulyx extends StatelessWidget {
  const Kulyx({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}