import 'package:flutter_ecoshops/services/entership_service.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class AllFieldsFormBloc extends FormBloc<String, String> {
  final beOnKits = SelectFieldBloc(
    name: "be_on_kit",
    validators: [FieldBlocValidators.required],
    items: ['Sí', 'No'],
  );

  final rawMaterial = SelectFieldBloc(
    name: "raw",
    validators: [FieldBlocValidators.required],
    items: ['Sí', 'No'],
  );

  final descRawMaterial = TextFieldBloc(
    name: "raw_materials",
    validators: [FieldBlocValidators.required],
  );

  final minDisc = TextFieldBloc(
    name: 'max_discount',
    validators: [FieldBlocValidators.required],
  );

  final maxDisc = TextFieldBloc(
    name: 'min_discount',
    validators: [FieldBlocValidators.required],
  );

  final text1 = TextFieldBloc(
    name: 'entrepreneurship_name',
    validators: [FieldBlocValidators.required],
  );

  final text2 = TextFieldBloc(
    name: "user_social_media",
    validators: [FieldBlocValidators.required],
  );

  final text3 = TextFieldBloc(
    name: "descp_emp",
    validators: [FieldBlocValidators.required],
  );

  late EntrepreneurshipService entServices;
  late String userID;

  AllFieldsFormBloc(EntrepreneurshipService entrep, String id) {
    entServices = entrep;
    userID = id;

    addFieldBlocs(fieldBlocs: [
      text1,
      text2,
      text3,
      beOnKits,
      rawMaterial,
    ]);

    beOnKits.onValueChanges(
      onData: (previous, current) async* {
        removeFieldBlocs(
          fieldBlocs: [
            minDisc,
            maxDisc,
          ],
        );

        if (current.value == 'Sí') {
          addFieldBlocs(fieldBlocs: [
            minDisc,
            maxDisc,
          ]);
        }
      },
    );

    rawMaterial.onValueChanges(
      onData: (previous, current) async* {
        removeFieldBlocs(
          fieldBlocs: [
            descRawMaterial,
          ],
        );

        if (current.value == 'Sí') {
          addFieldBlocs(fieldBlocs: [
            descRawMaterial,
          ]);
        }
      },
    );
  }

  @override
  Future<void> close() {
    minDisc.close();
    maxDisc.close();
    descRawMaterial.close();

    return super.close();
  }

  @override
  void onSubmitting() async {
    try {
      var newEntrep = state.toJson();
      newEntrep.remove("raw");
      newEntrep["be_on_kit"] = (newEntrep["be_on_kit"] == "Sí");
      await entServices.register(newEntrep, userID);
      emitSuccess(canSubmitAgain: true);
    } catch (e) {
      print(e.toString());
      emitFailure();
    }
  }
}
