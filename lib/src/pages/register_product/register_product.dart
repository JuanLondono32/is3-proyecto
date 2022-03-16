import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/services/services.dart';
import 'package:flutter_ecoshops/src/pages/register_product/register_product_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../env.dart';
import '../register_entrepeneurship/register_entrepreneurship.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter_ecoshops/api/firebase_api.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:async/async.dart';
import 'dart:convert';

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

  final _apiUrl = Env.apiUrl;
  late File _image;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  upload(File imageFile) async {
    print("Hola estoy aqui");
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream(imageFile.openRead()));
    stream.cast();
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse('$_apiUrl/photo');
    print("Hola");
    print("$uri");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);
    String resultUpload = '';
    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print('value');
      print(value.runtimeType);
      final aux = jsonDecode(value);
      result = aux["image"];
      resultUpload = aux["image"];
      setState(() {});
    });
  }

  bool isloaded = false;
  String? result;
  // fetch() async {
  //   var response = await http.get(Uri.parse('$_apiUrl/image'));
  //   result = jsonDecode(response.body);
  //   print(result[0]['image']);
  //   setState(() {
  //     isloaded = true;
  //   });
  // }

  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context);
    final entServices = Provider.of<EntrepreneurshipService>(context);
    final prodServices = Provider.of<ProductsService>(context);
    return BlocProvider(
      create: (context) =>
          Fields(entServices, authServices.currentUser!.id!, prodServices),
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

                  authServices.currentUser!.role = 'e';

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
                            await getImage();
                            await upload(_image);
                          },

                          // {
                          //   var url = await _selectFile();
                          //   formBloc.imageURL = url;
                          // },
                          child: Text('Seleccionar foto'),
                        ),
                        SizedBox(height: 8),
                        Text(
                          result != null ? '$_apiUrl/$result' : '',
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
                          onPressed: () {
                            formBloc.imageURL = result ?? '';
                            formBloc.submit();
                          },
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

  // Future<String> _selectFile() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(
  //         source: ImageSource.gallery,
  //         imageQuality: 100,
  //         maxHeight: 720,
  //         maxWidth: 720);
  //     if (pickedFile != null) {
  //       _imageFile = File(pickedFile.path);
  //       _path = _imageFile!.path;
  //     } else {
  //       _path = '';
  //     }
  //     setState(() {});
  //     return _path;
  //   } catch (e) {
  //     _path = '';
  //     setState(() {});
  //     return _path;
  //   }
  //   // final result = await FilePicker.platform.pickFiles(allowMultiple: false);

  //   // final path = result!.files.single.path!;
  //   // setState(() => file = File(path));

  //   // final fileName = basename(file!.path);

  //   // final Reference storageReference =
  //   //     FirebaseStorage.instance.ref().child("Products");
  //   // UploadTask uploadTask = storageReference.child(fileName).putFile(file!);

  //   // String url = await (await uploadTask).ref.getDownloadURL();
  //   // print(url);
  //   // return url;
  // }
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
