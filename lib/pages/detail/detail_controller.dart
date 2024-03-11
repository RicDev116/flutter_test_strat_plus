import 'package:flutter_test_strat_plus/models/marvel_response_model.dart';
import 'package:get/get.dart';

class DetailController extends GetxController{

  late Character character;

  @override
  void onInit() {
    character = Get.arguments;
    super.onInit();
  }
}