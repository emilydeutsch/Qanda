import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.blue[900], Colors.blue[500],Colors.green[200]]
          )
      ),
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.blue[900],
          size: 50.0,
        ),
      ),
    );
  }
}