import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qanda/models/user.dart';
import 'package:qanda/services/auth.dart';
import 'package:qanda/services/database.dart';
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
  String email = '';
  String name = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {

    final questions = Provider.of<QuerySnapshot>(context);

    Map<String, dynamic> names;

    for (var doc in questions.documents) {


      if (doc.documentID == "users") {
        names = doc.data;

      }
    }
    print(names);


    return loading ? Loading() : StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().questions,
      child: Scaffold(
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
                            decoration: textInputDecoration.copyWith(hintText: 'Name'),
                            obscureText: false,
                            validator: (val) => val.isEmpty ? 'Enter your name' : null,
                            onChanged: (val) {
                              setState(() => name = val);
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
                            print("some thing:");
                            print(result);

                            names[result.uid] = name;
                            print(names);
                            await DatabaseService().createUserData(names);

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
      ),
    );
  }
}
