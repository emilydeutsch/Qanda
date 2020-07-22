import 'package:flutter/material.dart';
import 'package:qanda/services/auth.dart';
import 'package:qanda/shared/constants.dart';
import 'package:qanda/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  //TODO: Add username data
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.blue[900], Colors.blue[500],Colors.green[200]]
          )
      ),
        //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('''Welcome to Qanda''',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30,
              ),

            ),
            SizedBox(
              height: 285,
              child: Padding(
              padding: const EdgeInsets.all(8.0),
                child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 10,
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: Form(
                    key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                      setState(() => email = val);
                  }
                ),
                    ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RaisedButton(
                      color: Colors.blue[500],
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = 'please supply a valid email';
                            });
                          }
                        }
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 12.0),
                  ),
                )
              ],
            ),
          ),
      ),
    ),
    ),
    ),
              FlatButton.icon(
                  icon: Icon(Icons.person,color: Colors.white),
                  label: Text('I already have an account',style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    widget.toggleView();
                  }
              )
    ],
    ),
    ),
      ),
    );
  }
}
