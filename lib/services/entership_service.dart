import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecoshops/models/entrepreneurship.dart';
import 'package:flutter_ecoshops/repositories/entership_repository.dart';
import 'package:flutter_ecoshops/services/auth_service.dart';
import 'package:flutter_ecoshops/src/pages/register_entrepeneurship/register_entrepreneurship.dart';

class EntrepreneurshipService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _entrepreneurship;
  //newline
  final EntershipRepository _entershipRepository = EntershipRepository();
  final AuthService _authService = AuthService();
  late Entrepreneurship currentEntrepreneurship;

  EntrepreneurshipService() {
    //init();
    this.currentEntrepreneurship = new Entrepreneurship(
        be_on_kit: '',
        descripcion_emp: '',
        entrepreneurship_na: '',
        id_user: '',
        logo: '');
  }

  Future register(Map newEntrep, String userID) async {
    try {
      print('newEntrep');
      print(newEntrep);
      final resp = await _entershipRepository.registerEntrepreneurship(
          be_on_kit: newEntrep["be_on_kit"],
          description_emp: newEntrep["descp_emp"],
          id_user: userID,
          emp_name: newEntrep["entrepreneurship_name"],
          max_discount: newEntrep["max_discount"],
          min_discount: newEntrep["min_discount"],
          raw_materials: newEntrep["raw_materials"],
          social_media: newEntrep["user_social_media"]);
      print(resp);
    } catch (e) {
      print(e);
    }
  }

  Future<Entrepreneurship> getProfileByUserId(String userID) async {
    try {
      final resp =
          await _entershipRepository.getEntrepreneurship(id_user: userID);
      print(resp);
      var entrepreneuship = new Entrepreneurship.fromMap(resp as dynamic);

      return entrepreneuship;
    } catch (e) {
      print('error $e');
      return Entrepreneurship(
          be_on_kit: "true",
          descripcion_emp: "descripcion_emp",
          entrepreneurship_na: "entrepreneurship_na",
          id_user: "id_user",
          logo: "logo");
    }
  }

  Future<Entrepreneurship> getProfile(String entrepreneurshipID) async {
    try {
      final resp = await _entershipRepository
          .getEntrepreneurshipById(entrepreneurshipID);
      print('resp');
      print(resp);
      var entrepreneuship = new Entrepreneurship.fromMap(resp as dynamic);

      return entrepreneuship;
    } catch (e) {
      print('error $e');
      return Entrepreneurship(
          be_on_kit: "true",
          descripcion_emp: "descripcion_emp",
          entrepreneurship_na: "entrepreneurship_na",
          id_user: "id_user",
          logo: "logo");
    }
  }

  // Future<Entrepreneurship> getProfileByUserId(String userID) async {
  //   _entrepreneurship = _firestore.collection("entrepreneurship");
  //   var query =
  //       await _entrepreneurship.where("id_user", isEqualTo: userID).get();

  //   var profile = query.docs[0].data();
  //   var entrepreneuship = new Entrepreneurship.fromMap(profile as dynamic);
  //   entrepreneuship.id = query.docs[0].id;

  //   return entrepreneuship;
  // }
}
