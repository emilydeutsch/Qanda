import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qanda/screens/authenticate/authenticate.dart';
import 'package:qanda/screens/home/home.dart';
import 'package:qanda/models/user.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    //return either home or auth widget
    if (user == null) {
      return Authenticate();
    } else {
      return GridQuestionsView();
    }
  }
}
