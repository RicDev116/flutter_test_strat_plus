import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test_strat_plus/helpers/database_helper.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_test_strat_plus/models/marvel_response_model.dart';


class HomeController extends GetxController{

  static const String  _baseMarvelUrl = "https://gateway.marvel.com/v1/public/";
  late String _publicKey;
  late String _privateKey;

  late String _timestamp;
  late String _hash;

  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  RxInt charactersLenght = 0.obs;
  
  List<Character> characters = [];
  List<Character> charactersComplete = [];
  late DatabaseHelper _databaseHelper;

  TextEditingController textEditingSearchController = TextEditingController();
  


  @override
  void onInit() async{
    setKeysByEnv();
    initDataBase();
    initScrollListener();
    await getMarvelCharacters(20);
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

  Future<void>getMarvelCharacters(int limit)async{

    if(isLoading) return;
    updateIsLoading(true);

    _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _hash = generateMarvelApiHash();
    final Uri uri = Uri.parse(_baseMarvelUrl).replace(pathSegments: [...Uri.parse(_baseMarvelUrl).pathSegments, "characters"], queryParameters: {
      'apikey': _publicKey,
      'ts': _timestamp,
      'hash': _hash,
      'limit': limit.toString(),
      'offset':"${charactersLenght.value}",
    });
    var client = http.Client();
    try {
      var response = await client.get(uri);
      if(response.statusCode == 200 && response.body.isNotEmpty){
        await saveCharactersInDB(MarvelResponseModel.fromJson(json.decode(response.body)).data.characters);
        await getCharactersFromDB();
      }
    } catch (e) {
       print("Error HomeController: $e");
    }finally{
      client.close();
    }
    updateIsLoading(false);
  }

  ///Generate a api hash to autenticate in the marvel api
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
      if (scrollController.position.atEdge && scrollController.position.pixels != 0 && textEditingSearchController.text.isEmpty) {
        await getMarvelCharacters(10);
      }
    });
  }
  
  void initDataBase() {
    _databaseHelper = DatabaseHelper.instance;
  }
  
  Future<void> saveCharactersInDB(List<Character> characters)async{
    for (var character in characters) {
      int? thumbnailId;
      if(character.thumbnail != null){
        thumbnailId = await _databaseHelper.insertThumbnail(character.thumbnail!);            
      } 
      _databaseHelper.insertCharacter(character, thumbnailId);
    }
  }

  Future<void> getCharactersFromDB() async{
    final data = await _databaseHelper.getCharactersWithThumbnails(initalId: charactersLenght.value);
    characters.addAll(List<Character>.from(data.map((x) => Character.fromJsonDataBase(x))));
    charactersComplete = characters.map((e) => e).toList();
    charactersLenght.value = characters.length;
  }

  Future<void>searchOnDBByName() async{
    if(isLoading)return;
    updateIsLoading(true);
    if(textEditingSearchController.text.isNotEmpty){
      final data = await _databaseHelper.getCharactersWithThumbnails(characterName:textEditingSearchController.text,initalId: null);
      characters.clear();
      characters.addAll(List<Character>.from(data.map((x) => Character.fromJsonDataBase(x))));
    }else{
      characters = charactersComplete.map((e) => e).toList();
    }
    charactersLenght.value = characters.length;
    updateIsLoading(false);
  }
  
  void setKeysByEnv() {
    try {
      _publicKey = dotenv.env['PUBLIC_KEY']!;
      _privateKey = dotenv.env['PRIVATE_KEY']!; 
    } catch (e) {
      throw Exception('PUBLIC_KEY no encontrada en las variables de entorno');
    }
  }


}