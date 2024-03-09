import 'package:flutter/material.dart';

import 'package:flutter_test_strat_plus/pages/detail/detail_binding.dart';
import 'package:flutter_test_strat_plus/pages/detail/detail_page.dart';
import 'package:flutter_test_strat_plus/pages/home/home_binding.dart';
import 'package:flutter_test_strat_plus/pages/home/home_page.dart';
import 'package:get/get.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Test StratPlus',
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/details',
          page: () => const DetailPage(),
          binding: DetailBinding(),
        ),
      ],
    );
  }
}