import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ecoshops/formstatus.dart';
import 'package:meta/meta.dart';

import '../../../../services/entership_service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final String userID;
  final EntrepreneurshipService entServices;

  RegisterCubit({required this.userID, required this.entServices})
      : super(RegisterState());

  nombEmpChange(String nombre) {
    emit(state.copyWith(entrepreneurshiName: nombre));
  }

  descEmpChange(String desc) {
    emit(state.copyWith(descpEmp: desc));
  }

  userSocialChange(String nombre) {
    emit(state.copyWith(userSocialMedia: nombre));
  }

  minDiscChange(String value) {
    emit(state.copyWith(minDisc: value));
  }

  maxDiscChange(String value) {
    emit(state.copyWith(maxDisc: value));
  }

  beOnKitsChange(String beOnKits) {
    emit(state.copyWith(beOnKits: beOnKits));
  }

  submit() async {
    try {
      emit(state.copyWith(isSubmittedSuccess: FormStatus.submissionInProgress));
      var newEntrep = state.toJson();
      newEntrep["be_on_kit"] = (newEntrep["be_on_kit"] == "Sí").toString();
      await entServices.register(newEntrep, userID);
      emit(state.copyWith(isSubmittedSuccess: FormStatus.submissionSuccess));
      // emitSuccess(canSubmitAgain: true);
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(isSubmittedSuccess: FormStatus.submissionFailure));
      // emitFailure();
    }
  }
}
