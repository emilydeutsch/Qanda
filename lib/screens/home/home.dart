import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
    value: DatabaseService().questions,
    child: Scaffold(
          appBar: AppBar(
            title: Text("Today's Question"),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ],
          ),
          body: QABoxes(questionIndex: widget.questionIndex, listOfQuestions: widget.listOfQuestions)
    )
    );
  }
}





class QABoxes extends StatefulWidget {
  @override

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


  @override
  Widget build(BuildContext context) {

    final questions = Provider.of<QuerySnapshot>(context);


    List<dynamic> listOfAnswers = [];
    for (var doc in questions.documents) {
      if (doc.documentID == widget.listOfQuestions[widget.questionIndex]) {
        if (doc.data['answers'] != null) {
          listOfAnswers = doc.data['answers'];
        }
      }
    }

    return Container(
      width: double.infinity,
      color: Colors.black12,
      child: Column(
        children: <Widget>[
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
                                                child:Text("John Smith") //TODO: parse user name
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
                                                "Test Person", listOfAnswers+[_inputController.text]);




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
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {


  final _formKey = GlobalKey<FormState>();

  String question = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add new Question'),
        ),
        body: Center(
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
                              await DatabaseService(question: question).createQuestionData();


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

    final questions = Provider.of<QuerySnapshot>(context);
    //print(questions.documents);

    listOfQuestions.clear();
    for (var doc in questions.documents) {
      listOfQuestions.add(doc.documentID);
    }

    return Scaffold(
        appBar: AppBar(
        title: Text('All the Questions'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add),
                onPressed: (){Navigator.push(context,
                    MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddQuestionPage()));}
            ),
          ],
    ),
      body: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
        child: Image.asset(
          'assets/images/Mountain.jpg',
          height:300,
        ),
        ),
        Expanded(
        child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: listOfQuestions.length,
              itemBuilder: (BuildContext context, int index) {
              return Hero(
                  tag: 'question' +index.toString(),
                child:  Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              elevation: 10,
              margin:  EdgeInsets.all(5.0),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child:SingleChildScrollView(
                child:Column(
                  children: <Widget>[
                    Text(listOfQuestions[index], style: TextStyle(fontSize: 26.0)), //TODO: parse question
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
