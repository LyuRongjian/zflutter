import 'package:flutter/widgets.dart';
import '../../../zflutter.dart';
import 'dart:math' as math;

class ZRect extends ZShape {
  final double width;
  final double height;

  ZRect({
    super.key,
    required this.width,
    required this.height,
    required super.color,
    Color? backfaceColor,
    super.stroke,
    super.fill,
    super.front,
    super.closed = true,
  }) : super(
            backfaceColor: backfaceColor ?? color,
            path: performPath(width, height));

  static List<ZPathCommand> performPath(double width, double height) {
    final x = width / 2;
    final y = height / 2;
    return [
      ZMove.vector(ZVector.only(x: -x, y: -y)),
      ZLine.vector(ZVector.only(x: x, y: -y)),
      ZLine.vector(ZVector.only(x: x, y: y)),
      ZLine.vector(ZVector.only(x: -x, y: y))
    ];
  }
}

class ZRoundedRect extends ZShape {
  final double width;
  final double height;
  final double borderRadius;

  ZRoundedRect({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required super.color,
    super.backfaceColor,
    super.stroke,
    super.fill,
    super.front,
  }) : super(closed: true, path: performPath(width, height, borderRadius));

  static List<ZPathCommand> performPath(
      double width, double height, double borderRadius) {
    var xA = width / 2;
    var yA = height / 2;
    var shortSide = math.min(xA, yA);
    var cornerRadius = math.min(borderRadius, shortSide);
    var xB = xA - cornerRadius;
    var yB = yA - cornerRadius;
    var path = [
      // top right corner
      ZMove.vector(ZVector.only(x: xB, y: -yA)),
      ZArc.list(
        [
          ZVector.only(x: xA, y: -yA),
          ZVector.only(x: xA, y: -yB),
        ],
        // null,
      ),
    ];
    // bottom right corner
    if (yB != 0) {
      path.add(ZLine.vector(ZVector.only(x: xA, y: yB)));
    }
    path.add(ZArc.list(
      [
        ZVector.only(x: xA, y: yA),
        ZVector.only(x: xB, y: yA),
      ],
      // null,
    ));

    // bottom left corner
    if (xB != 0) {
      path.add(ZLine.vector(ZVector.only(x: -xB, y: yA)));
    }
    path.add(ZArc.list(
      [
        ZVector.only(x: -xA, y: yA),
        ZVector.only(x: -xA, y: yB),
      ],
      // null,
    ));

    // top left corner
    if (yB != 0) {
      path.add(ZLine.vector(ZVector.only(x: -xA, y: -yB)));
    }
    path.add(ZArc.list([
      ZVector.only(x: -xA, y: -yA),
      ZVector.only(x: -xB, y: -yA),
    ]));

    // back to top right corner
    if (xB != 0) {
      path.add(ZLine.vector(ZVector.only(x: xB, y: -yA)));
    }

    return path;
  }
}

class ZCircle extends ZShape {
  final double diameter;

  final int quarters;

  ZCircle({
    super.key,
    required this.diameter,
    this.quarters = 4,
    required super.color,
    super.closed = false,
    super.backfaceColor,
    super.stroke,
    super.fill,
    super.front,
  })  : assert(quarters >= 0 && quarters <= 4),
        super(path: ZEllipse.performPath(diameter, diameter, quarters));
}

class ZEllipse extends ZShape {
  final double width;
  final double height;

  final int quarters;

  ZEllipse({
    super.key,
    required this.width,
    required this.height,
    this.quarters = 4,
    required super.color,
    super.backfaceColor,
    super.stroke,
    super.fill,
    super.front,
  })  : assert(quarters >= 0 && quarters <= 4),
        super(closed: false, path: performPath(width, height, quarters));

  static List<ZPathCommand> performPath(
      double width, double height, int quarters) {
    var x = width / 2;
    var y = height / 2;

    var path = [
      ZLine.vector(ZVector.only(x: 0, y: -y)),
      ZArc.list(
        [
          ZVector.only(x: x, y: -y),
          ZVector.only(x: x, y: 0),
        ],
        // null,
      ),
    ];

    if (quarters > 1) {
      path.add(ZArc.list(
        [
          ZVector.only(x: x, y: y),
          ZVector.only(x: 0, y: y),
        ],
        // null,
      ));
    }
    if (quarters > 2) {
      path.add(ZArc.list(
        [
          ZVector.only(x: -x, y: y),
          ZVector.only(x: -x, y: 0),
        ],
        // null,
      ));
    }
    if (quarters > 3) {
      path.add(ZArc.list(
        [
          ZVector.only(x: -x, y: -y),
          ZVector.only(x: 0, y: -y),
        ],
        // null,
      ));
    }

    return path;
  }
}

class ZPolygon extends ZShape {
  final int sides;
  final double radius;

  ZPolygon({
    super.key,
    required this.sides,
    required this.radius,
    required super.color,
    super.backfaceColor,
    super.stroke,
    super.fill,
    super.front,
  })  : assert(sides > 2),
        assert(radius > 0),
        super(closed: true, path: performPath(sides, radius));

  static List<ZPathCommand> performPath(int sides, double radius) {
    return List.generate(sides, (index) {
      final double theta = index / sides * tau - tau / 4;
      final double x = math.cos(theta) * radius;
      final double y = math.sin(theta) * radius;
      return ZLine.vector(ZVector.only(x: x, y: y));
    });
  }
}
