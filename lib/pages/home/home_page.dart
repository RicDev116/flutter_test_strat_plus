import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test_strat_plus/pages/home/home_controller.dart';


class HomePage extends GetView<HomeController> {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personajes de marvel"),
      ),
      body: GetBuilder<HomeController>(
        id: "marvel-characters-list",
        builder: (homeController) {
          return Stack(
            fit: StackFit.expand,
            children: [
              homeController.marvelResponseModel == null
              ?Container()
              :Column(
                children: [
                  Text("${controller.charactersLenght.value} Personajes Cargados en la lista"),
                  Expanded(
                    child: ListView.builder(
                      controller: homeController.scrollController,
                      itemCount: homeController.marvelResponseModel!.data.results.length,
                      itemBuilder: (context, index) {
                        final character = homeController.marvelResponseModel!.data.results[index];
                        return ListTile(
                          onTap: () => Get.toNamed("/details",arguments: character),
                          leading: character.thumbnail != null
                          ?Image.network(
                            "${character.thumbnail!.path}.${character.thumbnail!.extension}", 
                            width: 50, 
                            height: 50
                          )
                          :Container(
                            color: Colors.grey,
                            width: 50, 
                            height: 50
                          ),
                          title: Text(character.name),
                          subtitle: Text(character.description),
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (homeController.isLoading) Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator()
                )
              ),
            ],
          );
        },
      )
    );
  }
}