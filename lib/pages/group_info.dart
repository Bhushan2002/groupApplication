import 'package:conversation/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo(
      {super.key,
      required this.groupName,
      required this.groupId,
      required this.adminName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMember();
  }

  getMember() async {
    DatabaseService(uId: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMember(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        // centerTitle: true,
        elevation: 9,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Group Information",
          style: TextStyle(fontSize: 24),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.exit_to_app))],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor:
              Theme.of(context).primaryColor.withOpacity(0.7),
              radius: 60,
              child: Text(
                widget.groupName.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 60,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: Container(
                width: double.infinity,
                padding: const  EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor.withOpacity(0.2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.groupName,

                      style:
                          const TextStyle(fontSize: 29,color: Colors.black45),
                    ),
                    Text(
                      "Admin: ${getName(widget.adminName)}",
                      style:
                      const TextStyle(fontSize: 16,color: Colors.black26),
                    ),
                  ],
                ),
              ),
            ),
            memberList(),
          ],
        ),
      ),

    );

  }
  memberList(){
    return StreamBuilder( stream: members, builder: (context, AsyncSnapshot snapshot){
      if(snapshot.hasData){
        if(snapshot.data["member"] != null){
          if(snapshot.data['member'].length != 0){
            return ListView.builder(itemCount: snapshot.data['member'].length,
                shrinkWrap: true,

                itemBuilder:(context, index){
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
                    child: Text(getName(snapshot.data['member'][index]).substring(0,1).toUpperCase(),style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: Colors.white),),
                  ),
                  title: Text(getName(snapshot.data["member"][index])),
                  subtitle: Text(getId(snapshot.data["member"][index]))
                ),
              );
                }
            );
          }else{
            return Center(
              child: Text('no member.'),
            );
          }
        }else{
          return Center(
            child: Text('no member.'),
          );
        }

      }
      else{
        return Center(
          child: CircularProgressIndicator( color: Theme.of(context).primaryColor,),
        );
      }
    });
  }
}
