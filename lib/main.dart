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
class _createQAPageState extends State<createQAPage> with SingleTickerProviderStateMixin{
  final List<String> _answers = <String>['answer1','answer2','answer3','answer4','answer5'];
  bool pressed = false;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Tween<Offset> direction =Tween<Offset>(
  begin:Offset(0,2),
  end: Offset.zero,
  );
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds:1),
      vsync: this,
    );

    _offsetAnimation = direction.animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


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
                    child:Column(
                      children: <Widget>[
                        Text("What is your favourite colour and why?", style: TextStyle(fontSize: 26.0)), //TODO: parse question
                        RaisedButton(
                          child: Text("Answer"),
                          onPressed:  _showText,
                        ),
                  ]
                  )
                  )
              )
            ),
          Expanded(
                child: Stack(
                     // alignment: Alignment.bottomCenter,
                    children:<Widget>[
                      Positioned.fill(child:
                          ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _answers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Center(child: Text(_answers[index], style: TextStyle(fontSize: 26.0))), //TODO: parse answer
                                );
                              }
                          ),
                      ),

                      SlideTransition(
                          position: _offsetAnimation,
                            child: Card(
                              elevation: 5,
                              margin:  EdgeInsets.all(8),
                              child:Column(
                                children: <Widget>[
                                  TextField(
                                    controller: TextEditingController(),
                                    maxLines: 11, //For it to expand while typing
                                    minLines: 3,
                                    decoration: const InputDecoration(
                                    hintText: 'Your Answer'
                                    ),
                                  ),
                                  Row(
                                    children: <Widget> [
                                      Expanded(
                                      child: RaisedButton(
                                        child: Text("Cancel"),
                                          onPressed: () {
                                            // ignore: unnecessary_statements
                                            _controller.reverse(from: 1.0);
                                          }
                                      ),
                                      ),
                                      Expanded(
                                      child: RaisedButton(
                                          child: Text("Submit"),
                                          onPressed: () {
                                            // ignore: unnecessary_statements
                                            //run time timeline in reverse with beginning changed
                                            direction.begin = Offset(0,-2);
                                            _controller.reverse(from: 1.0);
                                          }
                                      ),
                                      ),
                                  ]
                                  )
                                ]
                              )
                          ),
                          ),
                    ]
                  ),
          ),
          ],
        ),
    );
  }

  void _showText(){
    direction.begin = Offset(0,2);
    _controller.forward();
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



