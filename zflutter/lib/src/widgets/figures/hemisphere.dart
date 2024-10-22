import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../zflutter.dart';
import 'dart:math' as math;

class ZHemisphere extends StatelessWidget {
  final double diameter;

  final double stroke;

  final Color color;
  final bool visible;

  // final ZVector front;
  final Color? backfaceColor;

  //var front = ZVector.only(z: 1);
  const ZHemisphere({
    super.key,
    this.diameter = 1,
    this.stroke = 1,
    required this.color,
    this.visible = true,
    this.backfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.stack,
      children: [
        _ZCylinderMiddle(
          color: color,
          diameter: diameter,
          stroke: stroke,
        ),
        ZCircle(
          diameter: diameter,
          backfaceColor: backfaceColor,
          color: color,
          stroke: stroke,
          fill: true,
          key: null,
        ),
      ],
    );
  }
}

class _ZCylinderMiddle extends ZShape {
  final double diameter;

  _ZCylinderMiddle({
    required this.diameter,
    super.stroke,
    required super.color,
  }) : super(
          path: [],
        );

  @override
  _RenderZHemisphere createRenderObject(BuildContext context) {
    return _RenderZHemisphere(
      path: path,
      stroke: stroke,
      diameter: diameter,
      color: color,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderZHemisphere renderObject) {
    renderObject.diameter = diameter;
    renderObject.stroke = stroke;
    renderObject.path = path;
    renderObject.color = color;
  }
}

class _RenderZHemisphere extends RenderZShape {
  double _diameter;

  double get diameter => _diameter;

  set diameter(double value) {
    if (_diameter == value) return;
    _diameter = value;

    markNeedsPaint();
  }

  ZVector? apex;
  @override
  void performLayout() {
    final ZParentData anchorParentData = parentData as ZParentData;
    matrix4.setIdentity();
    // print('relayout ${anchorParentData.transforms.length}');
    apex = ZVector.only(z: diameter / 2);
    for (var matrix4 in anchorParentData.transforms.reversed) {
      //   print(matrix4);
      apex = apex?.transform(matrix4.translate, matrix4.rotate, matrix4.scale);
    }
    super.performLayout();
  }

  @override
  void performSort() {
    final renderCentroid = ZVector.lerp(origin, apex!, 3 / 8);
    sortValue = renderCentroid.z;
  }

  _RenderZHemisphere({
    super.path,
    required double diameter,
    required super.stroke,
    required super.color,
  })  : _diameter = diameter,
        super(backfaceColor: color, fill: true);

  @override
  void render(ZRenderer renderer) {
    final contourAngle = math.atan2(normalVector.y, normalVector.x);
    final demoRadius = diameter / 2 * normalVector.magnitude();
    final x = origin.x;
    final y = origin.y;

    final startAngle = contourAngle + tau / 4;
    final endAnchor = contourAngle - tau / 4;

    renderer.begin();
    renderer.move(origin);
    renderer.arc(x, y, demoRadius, startAngle, endAnchor);
    renderer.closePath();
    if (stroke > 0) renderer.stroke(color, stroke);
    if (fill) renderer.fill(color);
  }
}
