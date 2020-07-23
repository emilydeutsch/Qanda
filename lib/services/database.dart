import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String question;
  DatabaseService({ this.question });

  // collection reference
  final CollectionReference questionCollection = Firestore.instance.collection('questions');

  //TODO: ADD USERNAME TO QUESTION
  Future createQuestionData () async {
    return await questionCollection.document(question).setData({});
  }

  Future updateQuestionData (String name, List<dynamic> answers) async {
    return await questionCollection.document(question).setData({
      'name': name,
      'answers': answers,
    });
  }

  //get questions stream
  Stream<QuerySnapshot> get questions {
    return questionCollection.snapshots();
  }

}