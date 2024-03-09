import 'package:flutter_test_strat_plus/pages/detail/detail_controller.dart';
import 'package:get/get.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(() => DetailController(),fenix: true);
  }
}
