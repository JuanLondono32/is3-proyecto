import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/formstatus.dart';
import 'package:flutter_ecoshops/services/services.dart';
import 'package:flutter_ecoshops/src/pages/register_entrepeneurship/be_on_kits_builder.dart';
import 'package:flutter_ecoshops/src/pages/register_entrepeneurship/cubit/register_cubit.dart';
import 'package:flutter_ecoshops/src/pages/register_entrepeneurship/register_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:provider/provider.dart';

class RegisterEntrepreneurship extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context);
    final entServices = Provider.of<EntrepreneurshipService>(context);
    return BlocProvider(
      create: (context) =>
          AllFieldsFormBloc(entServices, authServices.currentUser!.id!),
      child: BlocProvider(
        create: (context) => RegisterCubit(
            entServices: entServices, userID: authServices.currentUser!.id!),
        child: Builder(
          builder: (context) {
            final formCubit = BlocProvider.of<RegisterCubit>(context);

            return Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Registrar Emprendimiento',
                      style: TextStyle(color: Colors.black)),
                  backgroundColor: Colors.lightGreen,
                ),
                body: BlocListener<RegisterCubit, RegisterState>(
                  listener: (context, state) {
                    if (state.isSubmittedSuccess ==
                        FormStatus.submissionInProgress) {
                      LoadingDialog.show(context);
                    }
                    if (state.isSubmittedSuccess ==
                        FormStatus.submissionSuccess) {
                      LoadingDialog.hide(context);

                      authServices.currentUser!.role = 'e';

                      Navigator.pop(context);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Los datos de usuario fueron actualizados correctamente."),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.lightGreen,
                      ));
                    }
                    if (state.isSubmittedSuccess ==
                        FormStatus.submissionFailure) {
                      LoadingDialog.hide(context);

                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Error')));
                    }
                  },
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            onChanged: (value) {
                              formCubit.nombEmpChange(value);
                            },
                            // textFieldBloc: formBloc.text1,
                            decoration: InputDecoration(
                              labelText: 'Nombre Emprendimiento',
                              prefixIcon: Icon(Icons.text_fields),
                            ),
                          ),
                          TextField(
                            onChanged: (value) {
                              formCubit.userSocialChange(value);
                            },
                            decoration: InputDecoration(
                              labelText: 'Usuario Redes Sociales',
                              prefixIcon: Icon(Icons.text_fields),
                            ),
                          ),
                          TextField(
                            onChanged: (value) {
                              formCubit.descEmpChange(value);
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Descripción',
                              prefixIcon: Icon(Icons.text_fields),
                            ),
                          ),
                          BeOnKitsBuilder(),
                          // RadioButtonGroupFieldBlocBuilder(
                          //   itemBuilder: (context, dynamic value) => value,
                          //   decoration: InputDecoration(
                          //     labelText: '¿Desea hacer parte de los kits? aaaa',
                          //     prefixIcon: SizedBox(),
                          //   ),
                          // ),
                          TextField(
                            onChanged: (value) {
                              formCubit.minDiscChange(value);
                            },
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: 'Descuento Mínimo',
                              prefixIcon: Icon(Icons.attach_money_rounded),
                            ),
                          ),
                          TextField(
                            onChanged: (value) {
                              formCubit.maxDiscChange(value);
                            },
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: 'Descuento Máximo',
                              prefixIcon: Icon(Icons.attach_money_rounded),
                            ),
                          ),

                          //EXPROPIADO
                          // RadioButtonGroupFieldBlocBuilder(
                          //   selectFieldBloc: formBloc.rawMaterial,
                          //   itemBuilder: (context, dynamic value) => value,
                          //   decoration: InputDecoration(
                          //     labelText: '¿Desea recibir materia prima?',
                          //     prefixIcon: SizedBox(),
                          //   ),
                          // ),
                          // TextFieldBlocBuilder(
                          //   textFieldBloc: formBloc.descRawMaterial,
                          //   keyboardType: TextInputType.text,
                          //   maxLines: 5,
                          //   decoration: InputDecoration(
                          //     labelText: 'Descripción Materia Prima',
                          //     prefixIcon: Icon(Icons.text_fields),
                          //   ),
                          // ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen),
                            //onPressed: formBloc.submit,
                            onPressed: () {
                              try {
                                print("si sirve");
                                formCubit.submit();
                              } catch (e) {
                                print("error");
                                print(e);
                              }
                            },
                            child: Text('Registrar asd'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

/*
class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => RegisterEntrepreneurship())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
