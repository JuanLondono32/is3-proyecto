import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ecoshops/models/user.dart';
import 'package:flutter_ecoshops/repositories/auth_repository.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository = AuthRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _users;
  Account? currentUser;

  AuthService() {
    init();
    this.currentUser = new Account(
        birthDate: DateTime.now(),
        mail: '',
        password: '',
        role: 'c',
        address: '');
  }

  Future<void> init() async {
    if (this.currentUser != null && this.currentUser!.id != null) {
      print('Users is logged');
    }
  }

  Future createAccount(BuildContext context) async {
    try {
      final resp = await _authRepository.createUserWithEmailAndPassword(
          email: currentUser!.mail,
          password: currentUser!.password,
          name: currentUser!.fullName,
          direc: currentUser!.address!);
      if (resp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Usuario registrado con éxito'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.lightGreen,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fallo al registrar'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.lightGreen,
        ));
      }
    } catch (e) {}
  }

  // Future createAccount(BuildContext context) async {
  //   try {
  //     // Save user in auth system
  //     UserCredential resp = await _auth.createUserWithEmailAndPassword(
  //         email: currentUser.mail, password: currentUser.password);
  //     var user = resp.user;

  //     // Save user in data base
  //     DocumentReference docRef = _users.doc(user!.uid);
  //     await docRef
  //         .set(currentUser.toMap())
  //         .whenComplete(() => print("Usuario agregado a la base de datos."))
  //         .catchError((e) => print(e));
  //   } on FirebaseAuthException catch (e) {
  //     var msj = 'Error de autenticación. Intente otra vez...';
  //     if (e.code == 'invalid-email') {
  //       msj = 'El correo ingresado no es válido.';
  //     } else if (e.code == 'weak-password') {
  //       msj = 'La contraseña ingresada no es segura.';
  //     } else if (e.code == 'email-already-in-use') {
  //       msj = 'Dirección de correo electrónico ya registrada.';
  //     }
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(msj),
  //       duration: Duration(seconds: 2),
  //       backgroundColor: Colors.lightGreen,
  //     ));
  //   }
  // }

  Future<bool> signIn(BuildContext context) async {
    try {
      final resp = await _authRepository.signInWithEmailAndPassword(
        email: currentUser!.mail,
        password: currentUser!.password,
      );
      if (resp != {}) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Login exitoso'),
        //   duration: Duration(seconds: 2),
        //   backgroundColor: Colors.lightGreen,

        this.currentUser = new Account.fromMap(resp as dynamic);
        this.currentUser!.id = resp["_id"];
        print(currentUser!.id);
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Credenciales invalidas'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.lightGreen,
        ));
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Future signIn(BuildContext context) async {
  //   try {
  //     UserCredential resp = await _auth.signInWithEmailAndPassword(
  //         email: currentUser.mail, password: currentUser.password);
  //     var user = resp.user;

  // var snap = await _users.doc(user!.uid).get();
  // this.currentUser = new Account.fromMap(snap.data() as dynamic);
  // this.currentUser.id = user.uid;

  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     var msj = 'Error de autenticación. Intente otra vez...';
  //     if (e.code == 'user-not-found') {
  //       msj = 'El usuario ingresado no se encuentra registrado.';
  //     } else if (e.code == 'wrong-password') {
  //       msj = 'La contraseña ingresada no coincide con el usuario.';
  //     } else if (e.code == 'invalid-email') {
  //       msj = 'Dirección de correo electrónico inválida.';
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(msj),
  //       duration: Duration(seconds: 2),
  //       backgroundColor: Colors.lightGreen,
  //     ));

  //     return false;
  //   }
  // }

  Future updateUser(Map updates) async {
    // obtener current_user como mapa
    var userID = this.currentUser!.id;
    print(userID);

    var cUser = this.currentUser!.toMap();
    print(cUser);
    updates.keys.forEach((key) {
      cUser[key] = updates[key];
    });
    print(cUser);

    // Actualizando el current_user
    print("Antes actualizar");
    this.currentUser = Account.fromMap(cUser);
    this.currentUser!.id = userID;
    print("Después actualizar");

    // Actualizando la base de datos
    print("Antes BD");
    await _users.doc(userID).set(this.currentUser!.toMap());
    print("Después BD");
  }

  Future signOut() async {
    this.currentUser = new Account(
        birthDate: DateTime.now(),
        mail: '',
        password: '',
        role: 'c',
        address: '');
    await _auth.signOut();
  }
}
