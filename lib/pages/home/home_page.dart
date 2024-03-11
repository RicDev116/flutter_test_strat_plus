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
        bottom: AppBar(
          title: TextField(
            controller: controller.textEditingSearchController,
            decoration: const InputDecoration(
              hintText: "Buscar nombre",
            ),
            onChanged: (value) async => await  controller.searchOnDBByName(),
            onEditingComplete: () async => await  controller.searchOnDBByName(),
          ),
        ),
      ),
      body: GetBuilder<HomeController>(
        id: "marvel-characters-list",
        builder: (homeController) {
          return Stack(
            fit: StackFit.expand,
            children: [
              homeController.characters.isEmpty
              ?const Center(
                child: Text("Sin personajes que mostrar"),
              )
              :Column(
                children: [
                  Text("${controller.charactersLenght.value} Personajes Cargados en la lista"),
                  Expanded(
                    child: ListView.builder(
                      controller: homeController.scrollController,
                      itemCount: homeController.characters.length,
                      itemBuilder: (context, index) {
                        final character = homeController.characters[index];
                        return ListTile(
                          onTap: () => Get.toNamed("/details",arguments: character),
                          leading: character.thumbnail != null
                          ?Image.network(
                            "${character.thumbnail!.path}.${character.thumbnail!.extension}", 
                            width: 50, 
                            height: 50,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child; // La imagen se ha cargado completamente
                              return  const CircularProgressIndicator();
                            }
                          )
                          :Container(
                            color: Colors.grey,
                            width: 50, 
                            height: 50
                          ),
                          title: Text(character.name),
                          subtitle: SizedBox(
                            height: 30,
                            // color: Colors.yellow,
                            child: Text(
                              character.description,
                              overflow: TextOverflow.ellipsis,
                            )
                          ),
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