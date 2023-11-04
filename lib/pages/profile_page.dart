import 'dart:io';

import 'package:conversation/pages/auth/login_page.dart';
import 'package:conversation/pages/auth/register_page.dart';
import 'package:conversation/pages/home_page.dart';
import 'package:conversation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;

  ProfilePage({super.key, required this.userName, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  File? _image;
  final imagePicker = ImagePicker();
  late String downloadUrl;
  Future imagePickerMethode() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No file selected", const Duration(milliseconds: 400));
      }
    });
  }

  Future uploadImage() async {
    // final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${uid}/images")
        .child("profilePic");
    await ref.putFile(_image!);

  }
  downloadImage()async{
    Reference ref = FirebaseStorage.instance.ref().child('${uid}/images').child('profilePic.jpeg');
    downloadUrl = (await ref.getDownloadURL());
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),

      // Drawer

      drawer: customDrawer(context, widget.userName, widget.email),

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        color: Colors.transparent,
                        height: 200,
                        child: Center(
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Container(
                                              height: 400,
                                              color: Colors.white,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      10),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(30),
                                                    child: SizedBox(
                                                      height: 500,
                                                      width:
                                                      double.infinity,
                                                      child: Column(
                                                        children: [
                                                          RichText(text: TextSpan(text: "Upload image",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 24,fontWeight: FontWeight.w600))),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child:
                                                            Container(
                                                              width: 350,
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    20),
                                                                border: Border.all(
                                                                    color: Theme.of(context)
                                                                        .primaryColor,
                                                                    width:
                                                                    2),
                                                              ),
                                                              child: Center(
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child: _image == null
                                                                          ? const Text(
                                                                        "No image selected",
                                                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                                                      )
                                                                          : Image.file(_image!),
                                                                    ),
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          imagePickerMethode();
                                                                        },
                                                                        child:
                                                                        Text("Selected image")),
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          uploadImage();
                                                                        },
                                                                        child:
                                                                        Text("Upload image")),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Text(
                                    'upload image',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(160, 50)),
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.black12),
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          Theme.of(context).primaryColor)),
                                ),
                                const Divider(
                                  height: 20,
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Remove Profile',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.black12),
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(160, 50)),
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          Theme.of(context).primaryColor)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: _image == null ? const Icon(
                Icons.account_circle_sharp,
                size: 200,
              ): CircleAvatar(
                backgroundImage: NetworkImage(downloadUrl),
                radius: 100,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                widget.userName.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w700),
              ),
            ),
            Divider(
              height: 20,
            ),
            Text(
              widget.email,
              style: TextStyle(fontSize: 17,),
            ),
          ],
        ),
      ),
    );
  }
}
// showDialog(
// context: context,
// builder: (context) {
// return AlertDialog(
// backgroundColor:
// Theme.of(context).primaryColor.withOpacity(0.9),
// title: const Text(
// 'select your image for profile picture.',
// style: TextStyle(color: Colors.white),
// ),
// actions: [
// ElevatedButton(
// onPressed: () {
// // Navigator.push(
// //   context,
// //   MaterialPageRoute(
// //     builder: (context) => ImageUpload(
// //       uid: FirebaseAuth
// //           .instance.currentUser!.uid,
// //     ),
// //   ),
// // );
// },
// child: const Text("Upload picture"),
// style: ButtonStyle(
// overlayColor:
// MaterialStateProperty.all(Colors.grey[800]),
// foregroundColor: MaterialStateProperty.all(
// Theme.of(context).primaryColor),
// backgroundColor:
// MaterialStateProperty.all(Colors.white)),
// ),
// ElevatedButton(
// onPressed: () {},
// child: const Text("Remove picture"),
// style: ButtonStyle(
// overlayColor:
// MaterialStateProperty.all(Colors.grey[800]),
// foregroundColor: MaterialStateProperty.all(
// Theme.of(context).primaryColor),
// backgroundColor:
// MaterialStateProperty.all(Colors.white)),
// ),
// ],
// );
// });
