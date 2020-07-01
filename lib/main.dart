import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "My app name",
        theme: ThemeData(primaryColor: Colors.grey,
        ),
        home: createQAPage()
    );
  }
}

// ignore: camel_case_types
class createQAPage extends StatefulWidget {
  @override
  _createQAPageState createState() => _createQAPageState();
}

// ignore: camel_case_types
class _createQAPageState extends State<createQAPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Question"),
        actions: [
          IconButton(icon: Icon(Icons.add),onPressed: _createNewQA)
        ],
      ),
      body: _QABoxes()
    );
  }
  // ignore: non_constant_identifier_names
  Widget _QABoxes(){
    return Container(
        width: double.infinity,
        child: Column(
          children:<Widget>[
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 10,
                margin:  EdgeInsets.all(5.0),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child:Text("What is your favourite colour and why?", style: TextStyle(fontSize: 26.0)), //TODO: parse question
                )
            )
          )
          ],

    ),

    );
  }
  void _createNewQA(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {

          return Scaffold(
            appBar: AppBar(
              title: Text('Add new Question or Answer'),
            ),
            body: Center(
              child: Text("Options to add Question or Answer"),
            ),
          );
        },
      ),
    );
  }
}


