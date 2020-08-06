import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qanda/screens/authenticate/sign_in.dart';
import 'package:qanda/models/user.dart';
import 'package:qanda/screens/home/CollapseCard.dart';
import 'package:qanda/screens/home/InputAnswerCard.dart';
import 'package:qanda/services/auth.dart';
import 'package:qanda/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qanda/shared/constants.dart';



// ignore: camel_case_types
class Home extends StatefulWidget {
  final int questionIndex;
  final List<String> listOfQuestions;
  Home({this.questionIndex, this.listOfQuestions});
  @override
  _HomeState createState() => _HomeState();
}

// ignore: camel_case_types
class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // Authorization stuff

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
    value: DatabaseService().questions,
    child: Scaffold(
          body: QABoxes(questionIndex: widget.questionIndex, listOfQuestions: widget.listOfQuestions)
    )
    );
  }
}





class QABoxes extends StatefulWidget {
  final int questionIndex;
  final List<String> listOfQuestions;
  QABoxes({this.questionIndex, this.listOfQuestions});
  @override
  _QABoxesState createState() => _QABoxesState();
}

class _QABoxesState extends State<QABoxes> {
  bool _isExpanded = true;
  String _slideType; //used to change the slide type od the input card
  TextEditingController _inputController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    final questions = Provider.of<QuerySnapshot>(context);

    String name = "";

    String Question_name = "";

    List<dynamic> listOfAnswers = [];
    List<dynamic> listOfNames = [];
    for (var doc in questions.documents) {
      if (doc.documentID == widget.listOfQuestions[widget.questionIndex]) {
        if (doc.data['answers'] != null) {
          listOfAnswers = doc.data['answers'];
          listOfNames = doc.data['names'];
        }
        Question_name = doc.data['name'];
      }
      if (doc.documentID == "users") {
        name = doc.data[user.uid];
        print(name);
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.blue[900], Colors.blue[500],Colors.green[200]]
          )
      ),
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Today's Question"),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(context,
                      SlideRightRoute(page:SignIn())
                  );
                },
              )
            ],
          ),
          SizedBox(
              width: double.infinity,
              child:Hero(
                  tag: 'question'+widget.questionIndex.toString(),
                  child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      elevation: 10,
                      margin:  EdgeInsets.all(5.0),
                      child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child:SingleChildScrollView(child:Column(
                              children: <Widget>[
                                Text(widget.listOfQuestions[widget.questionIndex], style: TextStyle(fontSize: 26.0)),

                                RaisedButton(
                                  child: Text("Expand/Collapse"),
                                  onPressed: (){
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                ),
                                RaisedButton(
                                  child: Text("Answer"),
                                  onPressed:(){  setState(() {
                                    _slideType = "Answer";
                                  });},
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: Colors.white,
                                    height: 40,
                                    child: Row(
                                        children: <Widget> [
                                          Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Icon(
                                                  Icons.account_circle,
                                                  size: 20.0
                                              )),
                                          Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child:Text(Question_name)
                                          )
                                        ]
                                    ),
                                  ),
                                ),
                              ]
                          )
                          )
                      )
                  )
              )
          ),
          Expanded(
            child:Stack(
              // alignment: Alignment.bottomCenter,
                children:<Widget>[
                  CollapseCard(
                    expand: _isExpanded,
                    child:Positioned.fill(child:
                    ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: listOfAnswers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              child:Column(
                                children: <Widget>[
                                  LimitedBox(
                                    maxHeight: 150,
                                    child: SingleChildScrollView(
                                      child:Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(listOfAnswers[index], style: TextStyle(fontSize: 16.0))),
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 40,
                                      child: Row(
                                          children: <Widget> [
                                            Padding(
                                                padding: EdgeInsets.all(3.0),
                                                child: Icon(
                                                    Icons.account_circle,
                                                    size: 20.0
                                                )),
                                            Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child:Text(listOfNames[index])
                                            )
                                          ]
                                      ),
                                    ),
                                  )
                                ],
                              )
                          );
                        }

                      ),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: InputAnswerCard(
                        setSlide: _slideType,
                        child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
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
                                              //_controller.reverse(from: 1.0);
                                              setState(() {
                                                _slideType = "Cancel";
                                              });
                                            }
                                        ),
                                        RaisedButton(
                                            child: Text("Submit"),
                                            onPressed: () async {
                                              print(listOfAnswers+[_inputController.text]);
                                              await DatabaseService(question: widget.listOfQuestions[widget.questionIndex]).updateQuestionData(
                                                  Question_name, listOfAnswers+[_inputController.text], listOfNames+[name]);




                                              // ignore: unnecessary_statements
                                              //run time timeline in reverse with beginning changed
                                              //direction.begin = Offset(0,-2);
                                              //_controller.reverse(from: 1.0);
                                              setState(() {
                                                _slideType = "Submit";
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
}

  // ignore: non_constant_identifier_names








class AddQuestionPage extends StatefulWidget {

  final String name;
  AddQuestionPage({this.name});

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {


  final _formKey = GlobalKey<FormState>();

  String question = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.blue[900], Colors.blue[500],Colors.green[200]]
              )
          ),
          child: Column(
            children: <Widget>[
              AppBar(
                  title: Text('Add new Question'),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child:Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      elevation: 15,
                      margin:  EdgeInsets.all(8),
                      child:Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: textInputDecoration.copyWith(hintText: 'New Question'),
                                maxLines: 10, //For it to expand while typing
                                minLines: 3,
                                  validator: (val) => val.isEmpty ? 'Enter a question' : null,
                                onChanged: (val) {
                                  setState(() => question = val);
                                }
                              ),
                            ),
                            RaisedButton(
                                child: Text("Submit"),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    await DatabaseService(question: question).createQuestionData(widget.name);


                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  }
                                }
                            ),
                          ]
                      )
                  ),
                )
              ),
            ],
          ),
        )
    );
  }
}








class GridQuestionsView extends StatefulWidget {
  @override
  _GridQuestionsViewState createState() => _GridQuestionsViewState();
}

class _GridQuestionsViewState extends State<GridQuestionsView> {
  final List<String> listOfQuestions = <String>[];
  @override








  Widget build(BuildContext context) {
    timeDilation=2.0;
    final AuthService _auth = AuthService();

    final user = Provider.of<User>(context);
    String name = "";

    final questions = Provider.of<QuerySnapshot>(context);
    //print(questions.documents);

    listOfQuestions.clear();
    for (var doc in questions.documents) {
      listOfQuestions.add(doc.documentID);

      if (doc.documentID == "users") {
        name = doc.data[user.uid];
        print(name);
      }
    }

    return Scaffold(
      drawer: Drawer(
        /*
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.blue[900], Colors.blue[500],Colors.green[200]]
                )
            ),

         */
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text("First Last"),
                  accountEmail: Text("email@mail.com") ,
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.blue ,
                  ),
                  decoration: BoxDecoration(color: Color.fromRGBO(150, 204, 179, 1)),
                ),

                ListTile(
                  title: Text('logout'),
                  trailing: Icon(Icons.exit_to_app),
                  onTap: ()async {
                    await _auth.signOut();
                    Navigator.push(context,
                        SlideRightRoute(page:SignIn())
                    );
                  },
                ),
              ],
            ),
          ),

      body: Builder(builder: (BuildContext context) { return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.blue[900], Colors.blue[500],Colors.green[200]]
            )
        ),
        child: Column(
        children: <Widget>[
          AppBar(
            title: Text('All the Questions'),
            backgroundColor: Colors.transparent,

            leading: IconButton(icon: Icon(Icons.settings),
              onPressed: (){
                Scaffold.of(context).openDrawer();
              }
            ),
            elevation: 0.0,
            actions: <Widget>[
              /*FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('logout'),
                textColor: Colors.white,
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(context,
                      SlideRightRoute(page:SignIn())
                  );
                },
              ),*/
              IconButton(icon: Icon(Icons.add),
                  onPressed: (){
                Navigator.push(context, MaterialPageRoute<void>(
                          builder: (BuildContext context) => AddQuestionPage(name: name)));
                }
              ),

            ],
          ),
          Expanded(
          child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                itemCount: listOfQuestions.length,
                itemBuilder: (BuildContext context, int index) {
                return Hero(
                    tag: 'question' +index.toString(),
                  child:  Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 0,
                margin:  EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child:SingleChildScrollView(
                  child:Column(
                    children: <Widget>[
                      Text(listOfQuestions[index], style: TextStyle(fontSize: 20.0)), //TODO: parse question
                      RaisedButton(
                          child:Text("GO"),
                          onPressed: () {
                            Navigator.push(context,
                                SlideRightRoute(page:Home(questionIndex: index, listOfQuestions: listOfQuestions))
                            );
                          }
                      ),
                    ],
                  ),
                ),
                      ),
                  )
              );
                }
          ),
)
    ],
        ),
      );
    },
      )
    );
  }
}


class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}
