import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_ecoshops/env.dart';
import 'package:flutter_ecoshops/services/auth_service.dart';
import 'package:flutter_ecoshops/src/pages/register_entrepeneurship/register_entrepreneurship.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductRepository {
  final AuthService _authService = AuthService();
  final _apiUrl = Env.apiUrl;
  final Dio _dio = Dio();
  registerProduct(Map product) async {
    try {
      final json = {
        "name_prod": product["name_prod"],
        "descp": product["descp"],
        "price": product["price"].toString(),
        "stock": product["stock"].toString(),
        "cat": product["cat"],
        "is_favourite": "false",
        "id_emprendimiento": product["id_entrepreneurship"],
        "image": product["image"].toString()
      };
      var url = Uri.parse('$_apiUrl/productos/registro');
      print(json);
      var response = await http.post(url, body: json);

      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('error $e');
    }
  }

  //Obtiene el emprendimiento del usuario
  getEntrepreneurship({
    required String id_user,
  }) async {
    try {
      var url = Uri.parse('$_apiUrl/emprendimientos/ver/$id_user');
      var response = await http.get(url);
      final resp = jsonDecode(response.body);
      final entrepreneur = resp["entres"];
      if (entrepreneur != null) {
        return entrepreneur;
      } else {
        return {};
      }
    } catch (e) {
      print('error $e');
    }
  }

  //Obtiene un producto
  getProduct(
    String idProduct,
  ) async {
    try {
      var url = Uri.parse('$_apiUrl/productos/producto/$idProduct');
      var response = await http.get(url);
      final resp = jsonDecode(response.body);
      final producto = resp["productos"];
      if (producto != null) {
        return producto;
      } else {
        return {};
      }
    } catch (e) {
      print('error $e');
    }
  }

  Future<dynamic> getProducts() async {
    try {
      var url = Uri.parse('$_apiUrl/productos');
      var response = await http.get(url);
      final resp = jsonDecode(response.body);
      var productos = resp["productos"];
      if (productos != null) {
        return productos;
      } else {
        return [];
      }
    } catch (e) {
      print('error $e');
    }
  }

  //Obtiene productos de mi emprendimiento
  Future<dynamic> getMyProducts(String entID) async {
    try {
      var url = Uri.parse('$_apiUrl/productos/$entID');
      var response = await http.get(url);
      final resp = jsonDecode(response.body);
      var productos = resp["productos"];
      if (productos != null) {
        return productos;
      } else {
        return [];
      }
    } catch (e) {
      print('error $e');
    }
  }

  //Obtiene los productos de la categoria
  Future<dynamic> getProductsOfCategory(String category) async {
    try {
      var url = Uri.parse('$_apiUrl/productos/categoria/$category');
      var response = await http.get(url);
      final resp = jsonDecode(response.body);
      print('RESP');
      print(category);
      print(resp);
      var productos = resp["productos"];
      if (productos != null) {
        return productos;
      } else {
        return [];
      }
    } catch (e) {
      print('error $e');
    }
  }

  // Future<String> uploadPhoto(XFile photo) async {
  //   var url = '$_apiUrl/photo';
  //   String fileName = photo.path.split('/').last;
  //   FormData formData = FormData.fromMap({
  //     "file": await MultipartFile.fromFile(photo.path, filename: fileName),
  //   });
  //   final response = await _dio.post('$url',
  //       data: formData, options: Options(responseType: ResponseType.json));
  //   print('response photo');
  //   print(response.data);
  //   return response.data["image"];
  // }

  Future<String> uploadPhoto(XFile photo) async {
    try {
      var url = '$_apiUrl/photo';
      String fileName = photo.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(photo.path, filename: fileName),
      });
      final response = await _dio.post('$url',
          data: formData, options: Options(responseType: ResponseType.json));
      print('response photo');
      print(response.data);
      return response.data["image"];
    } catch (e) {
      print('error subiendo imagen $e');
      return '';
    }
  }
}
