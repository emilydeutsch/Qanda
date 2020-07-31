import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {

  final String uid;
  UserDatabaseService({ this.uid});

  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future updateUserData(String name) async {
    return await userCollection.document(uid).setData({
      'name': name,
    });
  }


  //get users stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }
}