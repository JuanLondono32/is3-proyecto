import 'dart:convert';

import 'package:flutter_ecoshops/env.dart';
import 'package:flutter_ecoshops/services/auth_service.dart';
import 'package:flutter_ecoshops/src/pages/register_entrepeneurship/register_entrepreneurship.dart';
import 'package:http/http.dart' as http;

class EntershipRepository {
  final AuthService _authService = AuthService();
  final _apiUrl = Env.apiUrl;
  registerEntrepreneurship(
      {required String id_user,
      required bool be_on_kit,
      required String description_emp,
      required String emp_name,
      String? max_discount,
      String? min_discount,
      String? raw_materials,
      String? social_media}) async {
    try {
      final body = {
        "be_on_kit": be_on_kit.toString(),
        "id_user": id_user,
        "descripcion_emp": description_emp,
        "entrepreneurship_name": emp_name,
        "max_discount": max_discount ?? "",
        "min_discount": min_discount ?? "",
        "raw_materials": raw_materials ?? "",
        "social_media": social_media
      };
      print(body);
      var url = Uri.parse('$_apiUrl/emprendimientos/registro');
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('error $e');
    }
  }

  getEntrepreneurship({
    required String id_user,
  }) async {
    try {
      var url = Uri.parse('$_apiUrl/emprendimientos/user/$id_user');
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

  getEntrepreneurshipById(
    String idEmp,
  ) async {
    try {
      var url = Uri.parse('$_apiUrl/emprendimientos/$idEmp');
      var response = await http.get(url);
      print('response');
      print('$_apiUrl/emprendimientos/$idEmp');
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
}
