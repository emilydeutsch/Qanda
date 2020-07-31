import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String question;
  DatabaseService({ this.question });

  // collection reference
  final CollectionReference questionCollection = Firestore.instance.collection('questions');

  Future createQuestionData (String name) async {
    return await questionCollection.document(question).setData({
      'name': name,
    });
  }

  Future updateQuestionData (String name, List<dynamic> answers, List<dynamic> names) async {
    return await questionCollection.document(question).setData({
      'name': name,
      'answers': answers,
      'names': names,
    });
  }

  Future createUserData (Map<String, dynamic> names) async {
    return await questionCollection.document("users").setData(names);
  }

  //get questions stream
  Stream<QuerySnapshot> get questions {
    return questionCollection.snapshots();
  }

}