import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../zflutter.dart';

class ZCylinder extends StatelessWidget {
  final double diameter;
  final double length;

  final double stroke;
  final bool fill;

  final Color color;
  final bool visible;

  final Color backface;
  final Color? frontface;

  const ZCylinder({
    super.key,
    this.diameter = 1,
    this.length = 1,
    this.stroke = 1,
    this.fill = true,
    required this.color,
    this.visible = true,
    this.frontface,
    required this.backface,
  });

  @override
  Widget build(BuildContext context) {
    final baseZ = length / 2;
    final baseColor = backface;
    final frontBase = ZPositioned(
      translate: ZVector.only(z: baseZ),
      rotate: const ZVector.only(y: (tau / 2)),
      child: ZCircle(
        diameter: diameter,
        color: color,
        stroke: stroke,
        fill: fill,
        backfaceColor: frontface ?? baseColor,
      ),
    );

    final backBase = ZPositioned(
      translate: ZVector.only(z: -baseZ),
      rotate: const ZVector.only(y: 0),
      child: ZCircle(
        diameter: diameter,
        color: color,
        stroke: stroke,
        fill: fill,
        backfaceColor: baseColor,
      ),
    );

    return ZGroup(
      children: [
        frontBase,
        backBase,
        _ZCylinderMiddle(
          color: color,
          diameter: diameter,
          stroke: stroke,
          path: [
            ZMove.vector(ZVector.only(z: baseZ)),
            ZLine.vector(
              ZVector.only(z: -baseZ),
            )
          ],
        )
      ],
    );
  }
}

class _ZCylinderMiddle extends ZShape {
  final double diameter;

  _ZCylinderMiddle(
      {required this.diameter,
      required super.path,
      super.stroke,
      required super.color});

  @override
  RenderZCylinder createRenderObject(BuildContext context) {
    return RenderZCylinder(
        path: path, stroke: stroke, diameter: diameter, color: color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderZCylinder renderObject) {
    renderObject.diameter = diameter;
    renderObject.stroke = stroke;
    renderObject.path = path;
    renderObject.color = color;
  }
}

class RenderZCylinder extends RenderZShape {
  double _diameter;

  double get diameter => _diameter;

  set diameter(double value) {
    if (_diameter == value) return;
    _diameter = value;

    markNeedsPaint();
  }

  RenderZCylinder({
    super.path,
    required double diameter,
    required super.stroke,
    required super.color,
  })  : _diameter = diameter,
        super(backfaceColor: color);

  @override
  void render(ZRenderer renderer) {
    var scale = normalVector.magnitude();
    var strokeWidth = diameter * scale + stroke;

    renderer.setLineCap(StrokeCap.butt);
    renderer.renderPath(transformedPath);
    renderer.stroke(color, strokeWidth);
    renderer.setLineCap(StrokeCap.round);
    super.render(renderer);
  }
}
