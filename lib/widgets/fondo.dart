import 'dart:math';
import 'package:flutter/material.dart';

class Fondo extends StatefulWidget {
  @override
  _FondoState createState() => _FondoState();
}

class _FondoState extends State<Fondo> {
  @override
  Widget build(BuildContext context) {
    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: FractionalOffset(0.0, 0.2),
        end: FractionalOffset(0.0, 0.6),
        colors: [
          Color.fromRGBO(13, 0, 255, 1.0),
          Color.fromRGBO(175, 0, 255, 1.0)
        ],
      )),
    );

    final cajaAzul = Transform.rotate(
      angle: -pi / 13.2,
      child: Container(
        height: 460.0,
        width: 460.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(175.0),
          gradient:
              LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
        ),
      ),
    );

    final cajaVerde = Transform.rotate(
      angle: -pi / 1.1,
      child: Container(
        height: 460.0,
        width: 460.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(155.0),
          gradient:
              LinearGradient(colors: [Colors.lightGreen, Colors.greenAccent]),
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        gradiente,
        Positioned(top: -100, child: cajaAzul),
        Positioned(bottom: -100, child: cajaVerde),
      ],
    );
  }
}
