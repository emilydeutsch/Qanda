import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qanda/screens/wrapper.dart';
import 'package:qanda/services/auth.dart';
import 'package:qanda/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          title: "My app name",
          theme: ThemeData(primaryColor: Colors.purple,),
          home: Wrapper()
      ),
    );
  }
}
