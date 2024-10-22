import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: Scaffold(
      //   body: Center(
      //     child: CustomPaintRoute(),
      //   ),
      // ),
      home: Scenario(),
    );
  }
}

class Car extends StatefulWidget {
  const Car({super.key});

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  @override
  Widget build(BuildContext context) {
    return ZDragDetector(
      builder: (context, controller) {
        return ZIllustration(
          children: [
            ZPositioned(
              rotate: controller.rotate,
              child: ZGroup(children: [
                ZPositioned(
                    rotate: const ZVector.only(x: tau / 4, z: tau / 4),
                    translate: const ZVector.only(x: 30, z: 20),
                    child: ZRoundedRect(
                      width: 10,
                      height: 80,
                      borderRadius: 3,
                      stroke: 20,
                      color: Colors.red,
                    )),
                ZPositioned(
                    translate: const ZVector.only(z: 0),
                    // rotate: const ZVector.only(y: tau / 4),
                    child: ZCircle(
                      diameter: 20,
                      stroke: 10,
                      color: Colors.black,
                    )),
                ZPositioned(
                    translate: const ZVector.only(z: 40),
                    // rotate: const ZVector.only(x: tau / 4),
                    child: ZCircle(
                      diameter: 20,
                      stroke: 10,
                      color: Colors.black,
                    )),
                ZPositioned(
                    translate: const ZVector.only(z: 0, x: 60),
                    // rotate: const ZVector.only(x: tau / 4),
                    child: ZCircle(
                      diameter: 20,
                      stroke: 10,
                      color: Colors.black,
                    )),
                ZPositioned(
                    translate: const ZVector.only(z: 40, x: 60),
                    // rotate: const ZVector.only(x: tau / 4),
                    child: ZCircle(
                      diameter: 20,
                      stroke: 10,
                      color: Colors.black,
                    )),
              ]),
            ),
          ],
        );
      },
    );
  }
}

class Scenario extends StatefulWidget {
  const Scenario({super.key});

  @override
  State<Scenario> createState() => _ScenarioState();
}

class _ScenarioState extends State<Scenario> {
  @override
  Widget build(BuildContext context) {
    return ZDragDetector(
        builder: (context, controller) => ZIllustration(children: [
              ZPositioned(
                  rotate: controller.rotate,
                  child: ZPositioned(
                    // rotate: const ZVector.only(x: tau / 4),
                    child: ZGroup(
                      children: const [
                        Tree(x: 100),
                        Ground(),
                      ],
                    ),
                  ))
            ]));
  }
}

class Ground extends StatelessWidget {
  const Ground({super.key});

  @override
  Widget build(BuildContext context) {
    return ZPositioned(
      rotate: const ZVector.only(x: tau / 4),
      child: ZGroup(children: [
        ZRect(
          width: 3000,
          height: 3000,
          color: Colors.green,
          fill: true,
        ),
        ZCircle(
          diameter: 10,
          color: Colors.blue,
          backfaceColor: Colors.blue,
        )
      ]),
    );
  }
}

class Tree extends StatelessWidget {
  const Tree(
      {super.key,
      this.x = 0,
      this.y = 0,
      this.z = 0,
      this.height = 40,
      this.crown = 100});
  final double x, y, z;
  final double height;
  final double crown;
  @override
  Widget build(BuildContext context) {
    return ZPositioned(
      translate: ZVector.only(x: x, y: y, z: z),
      rotate: const ZVector.only(x: tau / 4),
      child: ZGroup(
        children: [
          ZPositioned(
            translate: ZVector.only(z: height + crown / 2),
            child: ZShape(
              color: Colors.greenAccent,
              stroke: crown,
            ),
          ),
          ZPositioned(
            rotate: const ZVector.only(x: tau / 4),
            child: ZRect(
              color: Colors.brown,
              width: 3,
              height: height,
              stroke: 10,
              fill: true,
            ),
          ),
        ],
      ),
    );
  }
}
