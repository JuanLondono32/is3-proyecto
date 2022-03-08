import 'dart:convert';

import 'package:flutter_ecoshops/env.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final _apiUrl = Env.apiUrl;

  createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String? name,
      required String direc}) async {
    try {
      final body = {
        "mail": email,
        "password": password,
        "fullName": name ?? "",
        "address": direc,
      };
      var url = Uri.parse('$_apiUrl/users/registro');
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

  signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final body = {"mail": email, "password": password};
      var url = Uri.parse('$_apiUrl/users/login');
      var response = await http.post(url, body: body);
      final resp = jsonDecode(response.body);
      final user = resp["users"];
      if (user != null) {
        print('user $user');
        return user;
      } else {
        return {};
      }
    } catch (e) {
      print('error $e');
    }
  }
}
