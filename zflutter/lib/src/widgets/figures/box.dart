import 'package:flutter/material.dart';

import '../../../zflutter.dart';

class ZBox extends StatelessWidget {
  final double width;
  final double height;
  final double depth;

  final double stroke;
  final bool fill;

  final Color color;
  final bool visible;

  final Color? frontColor;
  final Color? rearColor;
  final Color? leftColor;
  final Color? rightColor;
  final Color? topColor;
  final Color? bottomColor;

  const ZBox({
    super.key,
    this.width = 100,
    this.height = 100,
    this.depth = 100,
    this.stroke = 1,
    this.fill = true,
    this.color = Colors.red,
    this.visible = true,
    this.frontColor,
    this.rearColor,
    this.leftColor,
    this.rightColor,
    this.topColor,
    this.bottomColor,
  });

  Widget get frontFace => ZPositioned(
        translate: ZVector.only(z: depth / 2),
        child: ZRect(
          color: frontColor ?? color,
          fill: fill,
          stroke: 1,
          width: width,
          height: height,
        ),
      );

  Widget get rearFace => ZPositioned(
        translate: ZVector.only(z: -depth / 2),
        rotate: const ZVector.only(y: tau / 2),
        child: ZRect(
          width: width,
          height: height,
          color: rearColor ?? color,
          fill: fill,
          stroke: 1,
        ),
      );

  Widget get leftFace => ZPositioned(
        translate: ZVector.only(x: -width / 2),
        rotate: const ZVector.only(y: -tau / 4),
        child: ZRect(
          width: depth,
          height: height,
          stroke: 1,
          color: leftColor ?? color,
          fill: fill,
        ),
      );

  Widget get rightFace => ZPositioned(
        translate: ZVector.only(x: width / 2),
        rotate: const ZVector.only(y: tau / 4),
        child: ZRect(
          width: depth,
          color: rightColor ?? color,
          height: height,
          stroke: 1,
          fill: fill,
        ),
      );

  Widget get topFace => ZPositioned(
        translate: ZVector.only(y: -height / 2),
        rotate: const ZVector.only(x: -tau / 4),
        child: ZRect(
          width: width,
          color: topColor ?? color,
          height: depth,
          stroke: 1,
          fill: fill,
        ),
      );

  Widget get bottomFace => ZPositioned(
        translate: ZVector.only(y: height / 2),
        rotate: const ZVector.only(x: tau / 4),
        child: ZRect(
          width: width,
          color: bottomColor ?? color,
          stroke: 1,
          fill: fill,
          height: depth,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      children: [
        frontFace,
        rearFace,
        leftFace,
        rightFace,
        topFace,
        bottomFace,
      ],
    );
  }
}
