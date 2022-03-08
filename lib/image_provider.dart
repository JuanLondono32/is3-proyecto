import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/env.dart';

Widget imageFromNetWork(String image) {
  final api = Env.urlImage;
  print(image);
  final newImage = image.replaceAll(r'\', r'/');
  return Image.network(
    image != ''
        ? '$api$newImage'
        : "https://assets.pokemon.com/assets/cms2/img/pokedex/full/094.png",
    fit: BoxFit.fill,
  );
}
