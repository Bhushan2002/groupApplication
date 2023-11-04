import 'dart:io';

import 'package:conversation/helper/helper_function.dart';
import 'package:conversation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";
  String email = "";
  bool _liked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();


  }
  getUserData() async{
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
  }
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadUrl;
  Future imagePickerMethode() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar(context, Colors.red, "no image is selected.");
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Feed",style: TextStyle(fontSize: 24),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {
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
                             
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }, icon: Icon(Icons.upload),),
          ),

        ],
      ),
      drawer: customDrawer(context, userName, email),
      body: Container(
        height: 400,
        color: Colors.blueGrey,
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.red,
              child: Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 1,vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(radius: 20,),
                    SizedBox(width: 15,),
                    Text(userName,style: TextStyle(fontSize: 18),),
                    SizedBox(width: 130,),
                    IconButton(onPressed: (){}, icon: Icon(Icons.menu))
                  ],
                ),
              ),
            ),
            Container(
              height: 300,
              child: Image.network(downloadUrl!),
            ),
            Container(
              height: 50,
              color: Colors.black12,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [

                   GestureDetector(onTap: (){
                     setState(() {
                       _liked = true;
                     });
                   },
                       onDoubleTap: (){
                     setState(() {
                       _liked = false;
                     });
                       },
                       child: Icon(_liked? Icons.favorite_border :Icons.favorite,color: _liked ? Colors.white: Colors.red,size: 30,)),
                    SizedBox(width: 10,),
                    IconButton(onPressed: (){}, icon: Icon(Icons.chat_bubble_outline,color: Colors.white,size: 30)),
                    SizedBox(width: 10,),
                    IconButton(onPressed: (){}, icon: Icon(Icons.send,color: Colors.white,size: 30)),
                    const SizedBox(width: 178,),
                    IconButton(onPressed: (){}, icon: Icon(Icons.save_alt,color: Colors.white,size: 30)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
