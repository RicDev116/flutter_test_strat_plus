import 'package:flutter_test_strat_plus/models/MarvelResponseModel.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DetailController extends GetxController{

  late Character character;

  @override
  void onInit() {
    character = Get.arguments;
    super.onInit();
  }
}