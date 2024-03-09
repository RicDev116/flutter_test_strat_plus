import 'package:flutter/material.dart';

import 'package:flutter_test_strat_plus/pages/detail/detail_controller.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class DetailPage extends GetView<DetailController> {

  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.character.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "${controller.character.thumbnail!.path}.${controller.character.thumbnail!.extension}",
              width: double.infinity,
              height: 300,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 8),
            if(controller.character.description.isNotEmpty)Text("Descripción"),
            if(controller.character.description.isNotEmpty)Text(controller.character.description),
            //TODO DEMÁS DATOS AQUI!!!,
          ],
        ),
      ),
    );
  }
}