import 'core.dart';

// TODO: This Paths needs to be immutable;

abstract class ZPathCommand {
  final ZVector endRenderPoint = ZVector.zero;

  void reset();

  ZPathCommand transform(ZVector translation, ZVector rotate, ZVector scale);

  void render(ZRenderer renderer);

  ZVector point({index = 0});

  ZVector renderPoint({int index = 0});

  set previous(ZVector previousPoint) {}

  ZPathCommand clone();
}

class ZMove extends ZPathCommand {
  late ZVector _point;

  late ZVector _renderPoint;

  @override
  ZVector get endRenderPoint => _renderPoint;

  ZMove.vector(this._point) {
    _renderPoint = _point.copy();
  }

  ZMove(double x, double y, double z) {
    _renderPoint = ZVector(x, y, z);
  }

  ZMove.only({double x = 0, double y = 0, double z = 0}) {
    _renderPoint = ZVector(x, y, z);
  }

  @override
  void reset() {
    _renderPoint = _point;
  }

  @override
  ZPathCommand transform(ZVector translation, ZVector rotate, ZVector scale) {
    return ZMove.vector(_renderPoint.transform(translation, rotate, scale));
  }

  @override
  void render(ZRenderer renderer) {
    renderer.move(_renderPoint);
  }

  @override
  ZVector point({index = 0}) {
    return _point;
  }

  @override
  ZVector renderPoint({index = 0}) {
    return _renderPoint;
  }

  @override
  ZPathCommand clone() {
    return ZMove.vector(point());
  }
}

class ZLine extends ZPathCommand {
  late ZVector _point;

  late ZVector _renderPoint;

  @override
  ZVector get endRenderPoint => _renderPoint;

  ZLine.vector(this._point) {
    _renderPoint = _point.copy();
  }

  ZLine(double x, double y, double z) {
    _renderPoint = ZVector(x, y, z);
  }

  ZLine.only({double x = 0, double y = 0, double z = 0}) {
    _renderPoint = ZVector(x, y, z);
  }

  @override
  void reset() {
    _renderPoint = _point;
  }

  @override
  ZPathCommand transform(ZVector translation, ZVector rotate, ZVector scale) {
    return ZLine.vector(_renderPoint.transform(translation, rotate, scale));
  }

  @override
  void render(ZRenderer renderer) {
    renderer.line(_renderPoint);
  }

  @override
  ZVector point({index = 0}) {
    return _point;
  }

  @override
  ZVector renderPoint({index = 0}) {
    return _renderPoint;
  }

  @override
  ZPathCommand clone() {
    return ZLine.vector(_point);
  }
}

class ZBezier extends ZPathCommand {
  late List<ZVector> points;

  late List<ZVector> renderPoints;

  @override
  ZVector get endRenderPoint => renderPoints.last;

  ZBezier(this.points) {
    renderPoints = points.map((e) => e.copy()).toList();
  }

  @override
  void reset() {
    /* renderPoints.asMap().forEach((index, vector) {
      vector.set(points[index]);
    });*/
  }

  @override
  ZPathCommand transform(ZVector translation, ZVector rotate, ZVector scale) {
    return ZBezier(renderPoints.map((point) {
      return point.transform(translation, rotate, scale);
    }).toList());
  }

  @override
  void render(ZRenderer renderer) {
    renderer.bezier(renderPoints[0], renderPoints[1], renderPoints[2]);
  }

  @override
  ZVector point({index = 0}) {
    return points[index];
  }

  @override
  ZVector renderPoint({index = 0}) {
    return renderPoints[index];
  }

  @override
  ZPathCommand clone() {
    return ZBezier(points);
  }
}

const double _arcHandleLength = 9 / 16;

class ZArc extends ZPathCommand {
  late List<ZVector> points;
  ZVector? _previous = ZVector.zero;

  late List<ZVector> renderPoints;

  @override
  ZVector get endRenderPoint => renderPoints.last;

  ZArc.list(this.points, [this._previous]) {
    renderPoints = points.map((e) => e.copy()).toList();
  }

  ZArc({required ZVector corner, required ZVector end, ZVector? previous}) {
    _previous = previous;

    points = [corner, end];

    renderPoints = points.map((e) => e.copy()).toList();
  }

  List<ZVector> controlPoints = [ZVector.zero, ZVector.zero];

  @override
  void reset() {
    renderPoints = List.generate(renderPoints.length, (i) => points[i]);
  }

  @override
  ZPathCommand transform(ZVector translation, ZVector rotate, ZVector scale) {
    return ZArc.list(renderPoints.map((point) {
      return point.transform(translation, rotate, scale);
    }).toList());
  }

  @override
  void render(ZRenderer renderer) {
    var prev = _previous;
    var corner = renderPoints[0];
    var end = renderPoints[1];
    var a = ZVector.lerp(prev!, corner, _arcHandleLength);
    var b = ZVector.lerp(end, corner, _arcHandleLength);
    renderer.bezier(a, b, end);
  }

  @override
  ZVector point({index = 0}) {
    return points[index];
  }

  @override
  ZVector renderPoint({index = 0}) {
    return renderPoints[index];
  }

  @override
  set previous(ZVector previousPoint) {
    _previous = previousPoint;
  }

  @override
  ZPathCommand clone() {
    return ZArc.list(points, _previous);
  }
}
