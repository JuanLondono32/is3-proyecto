import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/src/pages/register_entrepeneurship/cubit/register_cubit.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class BeOnKitsBuilder extends StatefulWidget {
  BeOnKitsBuilder({Key? key}) : super(key: key);

  @override
  State<BeOnKitsBuilder> createState() => _BeOnKitsState();
}

class _BeOnKitsState extends State<BeOnKitsBuilder> {
  String? val;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Column(
          children: [
            ListTile(
              title: Text("Si"),
              leading: Radio<String>(
                value: 'Si',
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = value;
                  });
                  BlocProvider.of<RegisterCubit>(context)
                      .beOnKitsChange(value!);
                },
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              title: Text("No"),
              leading: Radio<String>(
                value: 'No',
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = value;
                  });
                  BlocProvider.of<RegisterCubit>(context)
                      .beOnKitsChange(value!);
                },
                activeColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}
