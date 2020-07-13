import 'package:flutter/material.dart';
import 'package:qanda/screens/authenticate/authenticate.dart';
import 'package:qanda/screens/home/home.dart';
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    //return either home or auth widget
    return Home();
  }
}
