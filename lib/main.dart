import 'package:flutter/material.dart';
import 'package:qanda/screens/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "My app name",
        theme: ThemeData(primaryColor: Colors.purple,),
        home: Wrapper()
    );
  }
}
