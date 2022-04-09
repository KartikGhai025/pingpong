import 'package:flutter/material.dart';
import 'dart:math';
import 'ball.dart';
import 'bat.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  late double width;
  late double height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  double poss = 10;
  late Animation<double> animation;
  late AnimationController controller;

  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  double increment = 5;
  Color clr = Colors.black;
  final List<Color> newclr = [
    Colors.red,
    Colors.blue,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.blueGrey,
    Colors.black,
    Colors.pink,
    Colors.orange,
    Colors.purpleAccent,
    Colors.teal,
    Colors.brown,
    Colors.indigo,
    Colors.deepOrange
  ];

  double randX = 1;
  double randY = 1;

  int score = 0;

  void checkBorders() {
    if (posX <= 0 && hDir == Direction.left) {
      clr = newclr[Random().nextInt(12)];
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - 50 && hDir == Direction.right) {
      hDir = Direction.left;
      clr = newclr[Random().nextInt(12)];
      randX = randomNumber();
    }
    if (posY >= height - 50 && vDir == Direction.down) {
      vDir = Direction.up;
      clr = newclr[Random().nextInt(12)];
      randY = randomNumber();
    }
    if (posY >= height - 50 - batHeight && vDir == Direction.down) {
      clr = Colors.transparent;
      randY = randomNumber();
      safeSetState(() {
        score++;
      });

      if (posX >= (batPosition - 50) && posX <= (batPosition + batWidth + 50)) {
        vDir = Direction.up;
      } else {
        controller.stop();
        showMessage(context);

      }
    }

    if (posY <= 0 && vDir == Direction.up) {
      randY = randomNumber();
      vDir = Direction.down;
      clr = newclr[Random().nextInt(12)];
    }
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  double randomNumber() {
    //this is a number between 0.5 and 1.5;
    var ran = Random();
    int myNum = ran.nextInt(101);
    return (50 + Random().nextInt(101)) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: Text('Game Over'),
            content: Text('Would you like to play again?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                  });
                  Navigator.of(context).pop();
                  controller.repeat();
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                  dispose();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initState() {
    //posX = 0;
    //posY = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1000).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        animation.addListener(() {
          setState(() {
            (hDir == Direction.right) ? posX += 0.01 : posX -= 0.01;
            (vDir == Direction.down) ? posY += 0.01 : posY -= 0.01;
          });
          checkBorders();
        });
      });
    });
    controller.forward();

    super.initState();
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width / 5;
      batHeight = height / 20;
      return Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 24,
            child: Text('Score: ' + score.toString()),
          ),

          Positioned(
            child: Ball(clr),
            top: posY,
            left: posX,
          ),
          // const Positioned(child: Ball(newclr), top: 0),
          Positioned(
              bottom: 10,
              left: batPosition,
              //top: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update),
                child: Bat(batWidth, batHeight),
              )),
          // Positioned(
          //   bottom: 0,
          //   child: Bat(batWidth, batHeight),
        ],
      );
    });
  }
}
