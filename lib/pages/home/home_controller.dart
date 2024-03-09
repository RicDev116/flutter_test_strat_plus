import 'dart:convert';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_test_strat_plus/models/MarvelResponseModel.dart';


class HomeController extends GetxController{

  static const String  _baseMarvelUrl = "https://gateway.marvel.com/v1/public/";
  static const String _publicKey = "f3ebd959ed825ef6bf1aea1a35bfa608";
  static const String _privateKey = "5f3bea8834a04fc6eacd89588973d4eb59329f3b";

  late String _timestamp;
  late String _hash;

  MarvelResponseModel? marvelResponseModel;
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  RxInt charactersLenght = 0.obs;


  @override
  void onInit() async{
    initScrollListener();
    await getMarvelCharacters();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.removeListener(() {});
    super.onClose();
  }

  Future<void>getMarvelCharacters()async{

    if(isLoading) return;
    updateIsLoading(true);

    _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _hash = generateMarvelApiHash();
    final Uri uri = Uri.parse(_baseMarvelUrl).replace(pathSegments: [...Uri.parse(_baseMarvelUrl).pathSegments, "characters"], queryParameters: {
      'apikey': _publicKey,
      'ts': _timestamp,
      'hash': _hash,
      'limit': marvelResponseModel == null
        ?"20"
        :"10",
      'offset':"${charactersLenght.value}",
    });
    var client = http.Client();
    try {
      var response = await client.get(uri);
      if(response.statusCode == 200 && response.body.isNotEmpty){
        if(marvelResponseModel == null){
          marvelResponseModel = MarvelResponseModel.fromJson(json.decode(response.body));
          charactersLenght.value = marvelResponseModel!.data.results.length;
        }else{
          marvelResponseModel!.data.results.addAll(MarvelResponseModel.fromJson(json.decode(response.body)).data.results);
          charactersLenght.value = marvelResponseModel!.data.results.length;
        }
        print(marvelResponseModel.toString());
      }
    } catch (e) {
       print("Error HomeController: $e");
    }finally{
      client.close();
    }
    updateIsLoading(false);
  }

  String generateMarvelApiHash() {
    var bytes = utf8.encode(_timestamp + _privateKey + _publicKey);
    var hash = md5.convert(bytes);
    return hash.toString();
  }

  void updateIsLoading(bool isLoading){
    this.isLoading = isLoading;
    update(["marvel-characters-list"]);
  } 
  
  void initScrollListener() {
    scrollController.addListener(() async{
      if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
        await getMarvelCharacters();
      }
    });
  }

}