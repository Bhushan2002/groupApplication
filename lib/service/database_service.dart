
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uId;

 
  DatabaseService( {required this.uId});

  //reference for our collection
  final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection  =
    FirebaseFirestore.instance.collection("groups");

  // saving user data
Future saveUserData(String fullName, String email) async{
  return await userCollection.doc(uId).set({
    "fullName": fullName,
    "email": email,
    "groups": [],
    "profilePic": "",
    "uid": uId,
  });
}

 Future gettingUserData(String email) async{
  QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
  return snapshot;

}

// getting user group

gettingUserGroup() async{
  return userCollection.doc(uId).snapshots();
}
//creating a group
  Future createGroup(String userName, String id,String groupName)async{
    DocumentReference groupDocumentReference = await groupCollection.add({
      "GroupName": groupName,
      "GroupIcon": "",
      "admin": "${id}_$userName",
      "member": [],
      "groupId": "",
      "recentMessageSender": "",
    });

    // update the members
    await groupDocumentReference.update({
      "member": FieldValue.arrayUnion(["${uId}_$userName"]),
      "groupId": groupDocumentReference.id,



    });
    DocumentReference userDocumentReference = userCollection.doc(uId);
    return await userDocumentReference.update({
      "groups" : FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"]),
    });
  }
}