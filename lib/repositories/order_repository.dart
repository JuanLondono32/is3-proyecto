import 'dart:convert';

import 'package:flutter_ecoshops/env.dart';
import 'package:http/http.dart' as http;

class OrderRepository {
  final _apiUrl = Env.apiUrl;
  registerOrder(Map order) async {
    try {
      // final json = {
      //   "name_prod": order["name_prod"],
      //   "descp": order["descp"],
      //   "price": order["price"].toString(),
      //   "stock": order["stock"].toString(),
      //   "cat": order["cat"],
      //   "is_favourite": "false",
      //   "id_user": order["id_entrepreneurship"],
      //   "image": [""].toString()
      // };
      var url = Uri.parse('$_apiUrl/orden/registro');
      var response = await http.post(url, body: order);
      final respDecoded = jsonDecode(response.body);
      final ordenResp = respDecoded["ordenes"];
      print(response.body);
      if (response.statusCode == 200) {
        return ordenResp;
      } else {
        return {};
      }
    } catch (e) {
      print('error $e');
    }
  }

  registerDetailOrder(Map order) async {
    try {
      var url = Uri.parse('$_apiUrl/orden/saveDetailOrder');
      var response = await http.post(url, body: order);
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

  //Obtiene las ordenes del usuario
  Future<List<Map<String, dynamic>>> getMyorders(String userID) async {
    try {
      var url = Uri.parse('$_apiUrl/orden/emprendimiento/$userID');
      var response = await http.get(url);
      final resp = jsonDecode(response.body);
      var ordenes = resp["ordenes"];
      List<Map<String, dynamic>> aux = List<Map<String, dynamic>>.from(ordenes);
      if (ordenes != null) {
        return aux;
      } else {
        return [];
      }
    } catch (e) {
      print('sdsds $e');
      return [];
    }
  }

  //obtiene los productos de la orden
  Future<List<Map<String, dynamic>>> getDetailsOrder(String orderID) async {
    try {
      var url = Uri.parse('$_apiUrl/orden/productos/$orderID');
      var response = await http.get(url);
      final resp = jsonDecode(response.body);
      var ordenes = resp["ordenes"];
      List<Map<String, dynamic>> aux = List<Map<String, dynamic>>.from(ordenes);
      if (ordenes != null) {
        return aux;
      } else {
        return [];
      }
    } catch (e) {
      print('error $e');
      return [];
    }
  }

  Future<dynamic> getMyProducts(String userID) async {
    try {
      var url = Uri.parse('$_apiUrl/orden/usuario/$userID');
      var response = await http.get(url);
      final resp = jsonDecode(response.body);
      var ordenes = resp["ordenes"];
      if (ordenes != null) {
        return ordenes;
      } else {
        return [];
      }
    } catch (e) {
      print('error $e');
    }
  }

  Future<dynamic> getMyEntOrders(String entID) async {
    try {
      var url = Uri.parse('$_apiUrl/orden/emprendimientos/$entID');
      var response = await http.get(url);
      final resp = jsonDecode(response.body);
      var ordenes = resp["ordenes"];
      List<Map<String, dynamic>> aux = List<Map<String, dynamic>>.from(ordenes);
      if (ordenes != null) {
        return aux;
      } else {
        return [];
      }
    } catch (e) {
      print('sdsds $e');
      return [];
    }
  }
}
