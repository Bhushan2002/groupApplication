import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversation/pages/group_info.dart';
import 'package:conversation/service/database_service.dart';
import 'package:conversation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {super.key,
      required this.groupName,
      required this.groupId,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<QuerySnapshot> chat;
  String admin = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatAndAdmin();
  }
  getChatAndAdmin(){
    DatabaseService(uId: FirebaseAuth.instance.currentUser!.uid).getChats(widget.groupId).then((val){
      setState(() {
        chat = val;
      });
    });
    DatabaseService(uId: FirebaseAuth.instance.currentUser!.uid).getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupName: widget.groupName,
                      groupId: widget.groupId,
                      adminName: admin,
                    ));
              },
              icon: Icon(Icons.info))
        ],
      ),
    );
  }
}
