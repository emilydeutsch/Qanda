import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "My app name",
        theme: ThemeData(primaryColor: Colors.purple,),
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
  final List<String> _answers = <String>['answer1','answer2','answer3','answer4','answer5'];
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
          children: <Widget>[
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
            ),
            Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _answers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Center(child: Text(_answers[index], style: TextStyle(fontSize: 14.0))),
                  );
                }
            ),
            )
          ],
        ),
    );
  }

  void _createNewQA(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final List<String> entries = <String>['A', 'B', 'C'];
          return Scaffold(
            appBar: AppBar(
              title: Text('Add new Question or Answer'),
            ),
            body: Center(
              //child: Text("Options to add Question or Answer"),
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Center(child: Text('Entry ${entries[index]}')),
                    );
                  }
              ),
            ),
          );
        },
      ),
    );
  }
}



