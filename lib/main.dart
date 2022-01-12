import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: MyChart()));
}

class MyChart extends StatefulWidget {
  const MyChart({Key? key}) : super(key: key);

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  List<int> points = [];
  bool expanded = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        body: Container(
            width: expanded ? MediaQuery.of(context).size.width: 200,
            height: expanded ? MediaQuery.of(context).size.height -
                AppBar().preferredSize.height : 200,
            child: CustomPaint(painter: MyPainter(points: points))));
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

    for (int i = 0; i < math.max(points.length, 50); i++) {
      int value = i < points.length ? points[i] : 0;
      double offset = i * intervalx;
      double offsety = lineheight - (lineheight / 100) * value;
      if (value > 0) {
        canvas.drawOval(
            Rect.fromLTWH(offset + margin - 5, offsety + margin - 5, 10, 10),
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
