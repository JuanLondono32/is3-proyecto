import 'dart:io';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/entership_service.dart';
import '../../../services/products_service.dart';

class Fields extends FormBloc<String, String> {
  final select1 = SelectFieldBloc(
    name: 'cat',
    items: ['Aseo', 'Vasos', 'Comida', 'Hogar', 'Otros'],
  );

  final text1 = TextFieldBloc(
    name: 'name_prod',
    validators: [FieldBlocValidators.required],
  );

  final text2 = TextFieldBloc(
    name: "descp",
    validators: [FieldBlocValidators.required],
  );

  final text3 = TextFieldBloc(
    name: 'price',
    validators: [FieldBlocValidators.required],
  );

  final text4 = TextFieldBloc(
    name: 'stock',
    validators: [FieldBlocValidators.required],
  );

  String imageURL = "";
  File? imageFile;

  late EntrepreneurshipService entServices;
  late String userID;
  late ProductsService prodServices;

  Fields(EntrepreneurshipService entrep, String id, ProductsService prod) {
    entServices = entrep;
    userID = id;
    prodServices = prod;

    addFieldBlocs(fieldBlocs: [
      text1,
      text2,
      text3,
      text4,
      select1,
    ]);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  void onSubmitting() async {
    try {
      var newProd = state.toJson();
      var entrep = await entServices.getProfileByUserId(userID);
      print('userID');
      print(userID);
      print(entrep);
      newProd["stock"] = int.parse(newProd["stock"]);
      newProd["price"] = int.parse(newProd["price"]);
      newProd["is_favourite"] = false;
      newProd["id_entrepreneurship"] = entrep.id;
      newProd["image"] = imageURL;

      print('imageURL $imageURL');
      print(newProd);

      await prodServices.insertProduct(newProd);

      emitSuccess(canSubmitAgain: true);
    } catch (e) {
      print(e.toString());
      emitFailure();
    }
  }
}
