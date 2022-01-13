import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:demo/server.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: MyChart()));
  // home: Container(
  //     color: Colors.white, child: Center(child: MyAnimationDemo()))));
}

class MyDraggable extends StatefulWidget {
  @override
  State<MyDraggable> createState() => _MyDraggableState();
}

class _MyDraggableState extends State<MyDraggable> {
  double marginleft = 10.0;
  double marginTop = 200.0;
  bool expand = true;
  bool showPopup = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: Colors.white),
      GestureDetector(
          child: Container(color: Colors.green, height: 150, width: 150),
          onTap: () async {
            print("click");

            //showPopup = true;
            showPopup = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text("yes")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text("no")),
                    ],
                  ));
                });

            setState(() {});
          }),
      if (true)
        IgnorePointer(
            child: Opacity(
                opacity: 0.8,
                child: Container(color: Colors.blue, height: 100, width: 100))),
      if (showPopup)
        GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                marginleft = max(marginleft + details.delta.dx, 0);
                marginTop = max(marginTop + details.delta.dy, 0);
              });
            },
            child: Container(
                margin: EdgeInsets.only(left: marginleft, top: marginTop),
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onLongPress: () {
                      showPopup = false;
                      setState(() {});
                    },
                    onTap: () {
                      setState(() {
                        expand = !expand;
                      });
                    },
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 225),
                        color: Colors.red,
                        height: expand ? 200 : 50)),
                height: 200,
                width: 200)),
    ]);
  }
}

class MyAnimationDemo extends StatefulWidget {
  @override
  State<MyAnimationDemo> createState() => _MyAnimationDemoState();
}

class _MyAnimationDemoState extends State<MyAnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

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
    return MyChart();
  }
}

class MyChart extends StatefulWidget {
  const MyChart({Key? key}) : super(key: key);

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> with SingleTickerProviderStateMixin {
  bool expanded = true;
  late AnimationController controller;
  late Animation<double> sizeAnimation;
  double baseScale = 200;
  @override
  void initState() {
    SymbolServer.instance.addListener(() {
      setState(() {});
    });
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
            alignment: Alignment.center,
            child: GestureDetector(
                onScaleStart: (ScaleStartDetails scaleStartDetails) {
                  baseScale = 200;
                },
                onScaleUpdate: (ScaleUpdateDetails scaleUpdateDetails) {
                  // don't update the UI if the scale didn't change
                  if (scaleUpdateDetails.scale == 1.0) {
                    return;
                  }
                  setState(() {
                    baseScale = (200 * scaleUpdateDetails.scale)
                        .clamp(200.0, MediaQuery.of(context).size.width * 2);
                  });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height,
                    child: CustomPaint(
                        painter: MyPainter(
                            points: SymbolServer.instance.airTemperatures))))));
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
      ..strokeWidth = size.width / 100
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
