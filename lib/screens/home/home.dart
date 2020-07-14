import 'package:flutter/material.dart';
import 'package:qanda/services/auth.dart';

// ignore: camel_case_types
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// ignore: camel_case_types
class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  final List<String> _answers = <String>['orem ipsum dolor sit amet, consectetur adipiscing elit. In eu metus eu sapien blandit ultrices. Praesent varius massa lorem, venenatis egestas dolor mattis et. In sed mi ut tellus venenatis porttitor. Donec nisl eros, porta a purus ut, feugiat imperdiet dolor. Curabitur cursus euismod leo ut feugiat. Cras augue orci, bibendum id ex eget, cursus eleifend libero. Mauris quis eros erat. Suspendisse potenti. Etiam varius venenatis odio, id suscipit ante aliquam id. Nulla non porta orci. Suspendisse a sapien et magna semper interdum non id neque.',
    'Sed molestie nisi nisl, sed mollis mi pharetra ut. Nulla facilisi. Vestibulum in aliquam urna. Integer nec porttitor purus. Donec purus odio, porttitor eu luctus ut, elementum ac dui. Praesent pretium bibendum ligula, ut rhoncus dolor congue vehicula. Fusce nec elementum dolor, id mattis velit. ',
    'Donec eu sapien quam. Nulla nisi augue, mollis in lacus non, pellentesque aliquet elit. Etiam lacinia est quis elit condimentum consectetur quis et lectus. Nullam volutpat nunc arcu, nec hendrerit justo mollis at. Pellentesque ac congue tellus. Ut consequat justo tempus ligula bibendum faucibus. Maecenas ac ipsum placerat, suscipit sem sit amet, molestie nunc. Nullam orci nisi, interdum et suscipit id, lobortis non eros. ',
    'Vestibulum tincidunt ut quam in mollis. Mauris sollicitudin sed ligula quis pharetra. Proin sit amet eleifend lacus, id placerat nulla. Suspendisse quis finibus metus, vel posuere odio. Integer interdum orci dui, a luctus lorem imperdiet nec. Sed ornare auctor feugiat. Suspendisse a condimentum nulla, ut suscipit est. Nam malesuada blandit elit. Sed porttitor diam vitae lorem ornare feugiat. Quisque varius vehicula accumsan. ',
    'Integer rutrum lorem quis imperdiet fermentum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Suspendisse at est erat. Donec convallis ullamcorper nunc, non porttitor ante volutpat mollis. Morbi vitae blandit nisi. Pellentesque vel eros vitae nisl mattis aliquet. Fusce sodales, mi et ullamcorper finibus, lorem mauris placerat est, sit amet facilisis mi enim sit amet mi. Vivamus finibus augue quis auctor placerat. '];
  bool pressed = false;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  TextEditingController _inputController = TextEditingController();
  Tween<Offset> direction =Tween<Offset>(
    begin:Offset(0,2),
    end: Offset.zero,
  );

  // Authorization stuff
  final AuthService _auth = AuthService();

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
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add),onPressed: _createNewQA),
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: _QABoxes()
    );
  }
  // ignore: non_constant_identifier_names
  Widget _QABoxes(){
    return Container(
      width: double.infinity,
      color: Colors.black12,
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
            child:Stack(
              // alignment: Alignment.bottomCenter,
                children:<Widget>[
                  Positioned.fill(child:
                  ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _answers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child:Column(
                              children: <Widget>[
                                LimitedBox(
                                  maxHeight: 150,
                                  child: SingleChildScrollView(
                                    child:Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(_answers[index], style: TextStyle(fontSize: 16.0))), //TODO: parse answer
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: Row(
                                      children: <Widget> [
                                        Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(
                                                Icons.account_circle,
                                                size: 20.0
                                            )),
                                        Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child:Text("John Smith") //TODO: parse user name
                                        )
                                      ]
                                  ),
                                  color: Colors.white,
                                ),

                              ],
                            )
                        );
                      }

                  ),
                  ),
                  SizedBox(
                    height: 300,
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: Card(
                          elevation: 15,
                          margin:  EdgeInsets.all(8),
                          child:Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _inputController,
                                    maxLines: 9, //For it to expand while typing
                                    minLines: 3,
                                    decoration: const InputDecoration(
                                        hintText: 'Your Answer'
                                    ),
                                  ),
                                ),
                                ButtonBar(
                                    children: <Widget> [
                                      RaisedButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            // ignore: unnecessary_statements
                                            _controller.reverse(from: 1.0);
                                          }
                                      ),
                                      RaisedButton(
                                          child: Text("Submit"),
                                          onPressed: () {
                                            // ignore: unnecessary_statements
                                            //run time timeline in reverse with beginning changed
                                            direction.begin = Offset(0,-2);
                                            _controller.reverse(from: 1.0);
                                            setState(() {
                                              _answers.add(_inputController.text);
                                              _inputController.clear();
                                            });
                                          }
                                      ),
                                    ]
                                )
                              ]
                          )
                      ),
                    ),
                  )
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


