import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/user_notifier.dart';

import 'imageModal.dart';

class FotoCargada extends StatefulWidget {
  @override
  _FotoCargadaState createState() => _FotoCargadaState();
}

class _FotoCargadaState extends State<FotoCargada> {
  PickedFile _imageFile;
  String imagePath;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    return Container(
      width: 150,
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          //Image.network("https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/2b9e864c-ada2-4520-ba5f-19d39faffa9b5915008143652343343.jpg?alt=media&token=6675f928-b98a-459a-ae51-4ed06dca09c0"),
          //Image.networs"https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/2b9e864c-ada2-4520-ba5f-19d39faffa9b5915008143652343343.jpg?alt=media&token=6675f928-b98a-459a-ae51-4ed06dca09c0"
          CircleAvatar(
            //backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/2b9e864c-ada2-4520-ba5f-19d39faffa9b5915008143652343343.jpg?alt=media&token=6675f928-b98a-459a-ae51-4ed06dca09c0"),
            backgroundImage: _imageFile == null
                ? NetworkImage(userNotifier.currentUsuario.url)
                : FileImage(File(_imageFile.path)),
            //:NetworkImage(imagePath),
          ),
          Positioned(
            right: -6,
            bottom: 0,
            child: SizedBox(
              height: 40,
              width: 40,
              child: FlatButton(
                padding: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => ImageModal()),
                  );
                },
                child: Image.asset(
                  'assets/images/camara.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}