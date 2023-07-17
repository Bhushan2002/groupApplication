import 'package:conversation/pages/chat_page.dart';
import 'package:conversation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile(
      {super.key,
      required this.userName,
      required this.groupName,
      required this.groupId});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
                groupName: widget.groupName,
                groupId: widget.groupId,
                userName: widget.userName));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).indicatorColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Join the Conversation as ${widget.userName}",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
