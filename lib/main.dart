import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
      home: Container(
          color: Colors.white, child: Center(child: MyAnimationDemo()))));
}

class MyAnimationDemo extends StatefulWidget {
  @override
  State<MyAnimationDemo> createState() => _MyAnimationDemoState();
}

class _MyAnimationDemoState extends State<MyAnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  double baseScale = 1 ;
  bool bigger = false;
  // late List<Color> colors = [
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.yellow
  // ];
  // late Color selectedColor = colors[0];
  // late double selectedSize = 100;
  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<double>(begin: 100, end: 150)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    controller.addListener(() {
      setState(() {});
    });

    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
    //     selectedColor = colors[Random().nextInt(colors.length)];
    //     selectedSize = (100 + Random().nextInt(25)).toDouble();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
        child: Text("animate me"),
        onPressed: () {
          if (bigger) controller.reverse();
          else controller.forward();
          bigger = !bigger;
        },
      ),
      GestureDetector(
        onScaleStart: (ScaleStartDetails scaleStartDetails) {
          baseScale = 1;
        },
      onScaleUpdate: (ScaleUpdateDetails scaleUpdateDetails) {
        // don't update the UI if the scale didn't change
        if (scaleUpdateDetails.scale == 1.0) {
          return;
        }
        setState(() {
          baseScale = (1 * scaleUpdateDetails.scale).clamp(0.5, 5.0);
        });
      },
        child:Container(
        // duration: Duration(milliseconds: 500),
        color: Colors.cyan,
        width: 200 * baseScale,
        height: 200 * baseScale,
        child:
      ))
    ]);
  }
}

class MyChart extends StatefulWidget {
  const MyChart({Key? key}) : super(key: key);

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> with SingleTickerProviderStateMixin {
  List<int> points = [];
  bool expanded = true;
  late AnimationController controller;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    sizeAnimation = Tween<double>(begin: 1, end: 1.2)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    sizeAnimation.addListener(() {
      setState(() {});
    });
    controller..repeat(reverse: true);

    points = [10, 20, 30, 35, 36, 37, 38, 39, 50];
    Timer t = Timer.periodic(Duration(seconds: 1), (t) {
      if (points.length > 50) points.removeAt(0);
      int p = points.last;
      int margin = math.Random().nextInt(25);
      int positive = (math.Random().nextInt(10) % 2);
      if (positive == 0) p = (p * (100 + margin) / 100).round();
      if (positive == 1) p = (p * (100 - margin) / 100).round();
      points.add(math.min(p, 100));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            icon: Icon(Icons.expand),
            onPressed: () {
              setState(() {
                expanded = !expanded;
              });
            },
          )
        ], title: Text("whatever")),
        body: Column(children: [
          Container(
              alignment: Alignment.center,
              height: 50,
              child: Text("Roasting",
                  style: TextStyle(fontSize: (12 * sizeAnimation.value)))),
          Container(
              width: expanded ? MediaQuery.of(context).size.width : 200,
              height: expanded
                  ? MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      100
                  : 200,
              child: CustomPaint(painter: MyPainter(points: points)))
        ]));
  }
}

class MyPainter extends CustomPainter {
  List<int> points;
  MyPainter({this.points = const []});

  @override
  void paint(Canvas canvas, Size size) {
    double margin = 50;
    double linewidth = size.width - (margin * 2);
    double lineheight = size.height - (margin * 2);
    double intervalx = linewidth / (math.max(points.length, 50) - 1);

    Path p = Path()
      ..moveTo(margin, margin)
      ..lineTo(margin, size.height - margin)
      ..lineTo(size.width - margin, size.height - margin);

    Paint paint = Paint()
      ..strokeWidth = 4
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    canvas.drawPath(p, paint);

    Path p2 = Path()..moveTo(margin, size.height - margin);
    for (int i = 0; i < math.max(points.length, 50); i++) {
      int value = i < points.length ? points[i] : 0;
      double offset = i * intervalx;
      double offsety = lineheight - (lineheight / 100) * value;
      if (value > 0) {
        p2.lineTo(offset + margin, offsety + margin);
      }
    }
    canvas.drawPath(p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
