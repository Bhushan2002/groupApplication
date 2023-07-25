import 'dart:io';
import 'dart:math';

import 'package:conversation/service/database_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  String? uid;
  ImageUpload({super.key, this.uid});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  // some initialization code
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadUrl;
  Future imagePickerMethode() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No file selected", Duration(milliseconds: 400));
      }
    });
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future uploadImage() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${widget.uid}/images")
        .child("post_$postID");
    await ref.putFile(_image!);
    downloadUrl = await ref.getDownloadURL();
    print(downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 550,
              width: double.infinity,
              child: Column(
                children: [
                  const Text("Upload Image"),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _image == null
                                  ? Text("No image selected")
                                  : Image.file(_image!),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  imagePickerMethode();
                                },
                                child: Text("Selected image")),
                            ElevatedButton(
                                onPressed: () {
                                  uploadImage();
                                },
                                child: Text("Upload image")),
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
    );
  }
}
