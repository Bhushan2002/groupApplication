import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uId;

  DatabaseService({this.uId});

  //reference for our collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving user data
  Future saveUserData(String fullName, String email) async {
    return await userCollection.doc(uId).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uId,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

// getting user group

  gettingUserGroup() async {
    return userCollection.doc(uId).snapshots();
  }

//creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
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
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"]),
    });
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }
  //getting group admin
   Future getGroupAdmin(String groupId) async{
     DocumentReference d = groupCollection.doc(groupId);
     DocumentSnapshot documentSnapshot = await d.get();
     return documentSnapshot['admin'];
   }

   //get group members
getGroupMember(String groupId)async{
    return groupCollection.doc(groupId).snapshots();
}
//search

searchByName(String groupName){
    return groupCollection.where("groupName", isEqualTo: groupName).get();
}
Future<bool> isUserJoined(String groupName, String groupId,String userName)async{
    DocumentReference userDocumentReference = userCollection.doc(uId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupId}_${groupName}")){
      return true;
    }
    else{
      return false;
    }
}

}
