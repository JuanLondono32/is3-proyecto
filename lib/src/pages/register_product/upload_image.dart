import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/services/services.dart';
import 'package:flutter_ecoshops/src/pages/register_product/register_product_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../register_entrepeneurship/register_entrepreneurship.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter_ecoshops/api/firebase_api.dart';

class RegisterProductPage extends StatefulWidget {
  @override
  RegisterProduct createState() => RegisterProduct();
}

class RegisterProduct extends State<RegisterProductPage> {
  File? _imageFile;
  late String _path;

  @override
  void initState() {
    _path = '';
    // TODO: implement initState
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context);
    final entServices = Provider.of<EntrepreneurshipService>(context);
    final prodServices = Provider.of<ProductsService>(context);
    return BlocProvider(
      create: (context) =>
          Fields(entServices, authServices.currentUser.id!, prodServices),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<Fields>(context);

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
                title: Text('Registrar Producto',
                    style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.lightGreen,
              ),
              body: FormBlocListener<Fields, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  authServices.currentUser.role = 'e';

                  Navigator.pop(context);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("El producto fue agregado correctamente."),
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
                            labelText: 'Nombre Producto',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        DropdownFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.select1,
                          decoration: InputDecoration(
                            labelText: 'Categoría',
                            prefixIcon: Icon(Icons.category_rounded),
                          ),
                          itemBuilder: (context, item) => item,
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.text2,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.text3,
                          decoration: InputDecoration(
                            labelText: 'Precio',
                            prefixIcon: Icon(Icons.attach_money_rounded),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.text4,
                          decoration: InputDecoration(
                            labelText: 'Stock',
                            prefixIcon:
                                Icon(Icons.production_quantity_limits_rounded),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen),
                          onPressed: () async {
                            var url = await _selectFile();
                            formBloc.imageURL = url;
                          },
                          child: Text('Seleccionar foto'),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _imageFile?.path ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 100,
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

  Future<String> _selectFile() async {
    try {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
          maxHeight: 720,
          maxWidth: 720);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _path = _imageFile!.path;
      } else {
        _path = '';
      }
      setState(() {});
      return _path;
    } catch (e) {
      _path = '';
      setState(() {});
      return _path;
    }
    // final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // final path = result!.files.single.path!;
    // setState(() => file = File(path));

    // final fileName = basename(file!.path);

    // final Reference storageReference =
    //     FirebaseStorage.instance.ref().child("Products");
    // UploadTask uploadTask = storageReference.child(fileName).putFile(file!);

    // String url = await (await uploadTask).ref.getDownloadURL();
    // print(url);
    // return url;
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
