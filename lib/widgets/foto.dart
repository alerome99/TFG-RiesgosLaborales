import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'imageModal.dart';

class Foto extends StatefulWidget {
  @override
  _FotoState createState() => _FotoState();
}

class _FotoState extends State<Foto> {
  PickedFile _imageFile;
  String imagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: _imageFile == null
                ? AssetImage('assets/images/usuario.png')
                : FileImage(File(_imageFile.path)),
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
