import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/services/services.dart';
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
          AllFieldsFormBloc(entServices, authServices.currentUser.id!),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AllFieldsFormBloc>(context);

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
              body: FormBlocListener<AllFieldsFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  authServices.currentUser.role = 'e';

                  Navigator.pop(context);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Los datos de usuario fueron actualizados correctamente."),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.lightGreen,
                  ));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse!)));
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.text1,
                          decoration: InputDecoration(
                            labelText: 'Nombre Emprendimiento',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.text2,
                          decoration: InputDecoration(
                            labelText: 'Usuario Redes Sociales',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          maxLines: 5,
                          textFieldBloc: formBloc.text3,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        RadioButtonGroupFieldBlocBuilder(
                          selectFieldBloc: formBloc.beOnKits,
                          itemBuilder: (context, dynamic value) => value,
                          decoration: InputDecoration(
                            labelText: '¿Desea hacer parte de los kits?',
                            prefixIcon: SizedBox(),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.minDisc,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Descuento Mínimo',
                            prefixIcon: Icon(Icons.attach_money_rounded),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.maxDisc,
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
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.descRawMaterial,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Descripción Materia Prima',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen),
                          onPressed: formBloc.submit,
                          child: Text('Registrar'),
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
