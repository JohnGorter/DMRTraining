import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: MyChart()));
}

class MyChart extends StatelessWidget {
  const MyChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("whatever")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height,
            child: CustomPaint(painter: MyPainter())));
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    List<int> points = [10, 20, 30, 35, 36, 37, 38, 39, 50];
    double margin = 50;
    double linewidth = size.width - (margin * 2);
    double lineheight = size.height - (margin * 2);
    double intervalx = linewidth / (points.length - 1);

    Path p = Path()
      ..moveTo(margin, margin)
      ..lineTo(margin, size.height - margin)
      ..lineTo(size.width - margin, size.height - margin);

    Paint paint = Paint()
      ..strokeWidth = 4
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    canvas.drawPath(p, paint);

    for (int i = 0; i < points.length; i++) {
      double offset = i * intervalx;
      double offsety = lineheight - (lineheight / 100) * points[i];
      canvas.drawOval(
          Rect.fromLTWH(offset + margin - 5, offsety + margin - 5, 10, 10),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
