import 'package:flutter/material.dart';
class Ball extends StatelessWidget {
   Color colr = Colors.black;
  Ball(this.colr);

  @override
  Widget build(BuildContext context) {
    const double diam = 30;
    return CircleAvatar(radius: diam,
    backgroundColor: colr,);
    //   Container(
    //   width: diam,
    //   height: diam,
    //   decoration:  BoxDecoration(
    //     color: Colors.amber[400],
    //     shape: BoxShape.circle,
    //   ),
    // );
  }
}
