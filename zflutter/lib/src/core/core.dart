import 'dart:ui';
import 'dart:math' as math;

export 'widgets/positioned.dart';
export 'widgets/shape.dart';
export 'widgets/widget.dart';
export 'render/render_box.dart';
export 'render/render_shape.dart';
export 'path_command.dart';
export 'renderer.dart';

export 'widgets/box_adapter.dart';

const tau = math.pi * 2;

// A immutable 3D vector
// Todo: Add unit test for this. It is important
class ZVector {
  final double x;
  final double y;
  final double z;

  const ZVector(this.x, this.y, this.z);

  const ZVector.only({this.x = 0, this.y = 0, this.z = 0});

  const ZVector.all(double value)
      : x = value,
        y = value,
        z = value;
  static const ZVector zero = ZVector.all(0);
  static const ZVector identity = ZVector.all(1);

  @override
  bool operator ==(other) =>
      other is ZVector && x == other.x && y == other.y && z == other.z;

  // @override
  // int get hashCode => hash3(x.hashCode, y.hashCode, z.hashCode);

  @override
  int get hashCode => Object.hashAll([x.hashCode, y.hashCode, z.hashCode]);

  ZVector add({double x = 0, double y = 0, double z = 0}) =>
      ZVector(this.x + x, this.y + y, this.z + z);

  ZVector subtract({double x = 0, double y = 0, double z = 0}) =>
      ZVector(this.x - x, this.y - y, this.z - z);

  ZVector subtractVector(ZVector other) =>
      ZVector(x - other.x, y - other.y, z - other.z);

  ZVector addVector(ZVector other) =>
      ZVector(x + other.x, y + other.y, z + other.z);

  ZVector rotate(ZVector rotation) =>
      rotateZ(rotation.z).rotateY(rotation.y).rotateX(rotation.x);

  ZVector rotateZ(double angle) => _rotateProperty(angle, x, y, 'z');

  ZVector rotateX(double angle) => _rotateProperty(angle, y, z, 'x');

  ZVector rotateY(double angle) => _rotateProperty(angle, x, z, 'y');

  ZVector _rotateProperty(
      double angle, double propA, double propB, String axis) {
    if (angle % tau == 0) {
      return this;
    }
    var cos = math.cos(angle);
    var sin = math.sin(angle);
    var a = propA * cos - propB * sin;
    var b = propB * cos + propA * sin;
    switch (axis) {
      case 'x':
        return ZVector(x, a, b);
      case 'y':
        return ZVector(a, y, b);
      case 'z':
        return ZVector(a, b, z);
      default:
        return this;
    }
  }

  ZVector multiply(ZVector scale) {
    final mx = scale.x;
    final my = scale.y;
    final mz = scale.z;
    return ZVector(x * mx, y * my, z * mz);
  }

  ZVector divide(ZVector scale) {
    final mx = scale.x;
    final my = scale.y;
    final mz = scale.z;
    return ZVector(x / mx, y / my, z / mz);
  }

  ZVector multiplyScalar(double scale) {
    final m = scale;
    return ZVector(x * m, y * m, z * m);
  }

  ZVector transform(ZVector translation, ZVector rotation, ZVector scale) {
    return multiply(scale).rotate(rotation).addVector(translation);
  }

  static ZVector lerp(ZVector a, ZVector b, double t) {
    final double x = lerpDouble(a.x, b.x, t)!;
    final double y = lerpDouble(a.y, b.y, t)!;
    final double z = lerpDouble(a.z, b.z, t)!;
    return ZVector(x, y, z);
  }

  double magnitude() {
    var sum = x * x + y * y + z * z;
    return getMagnitudeSqrt(sum);
  }

  double getMagnitudeSqrt(double sum) {
    // PERF: check if sum ~= 1 and skip sqrt
    if ((sum - 1).abs() < 0.00000001) {
      return 1;
    }
    return math.sqrt(sum);
  }

  double magnitude2d() {
    var sum = x * x + y * y;
    return getMagnitudeSqrt(sum);
  }

  ZVector copy() {
    return ZVector(x, y, z);
  }

  ZVector copyWith({double? x, double? y, double? z}) {
    return ZVector(x ?? this.x, y ?? this.y, z ?? this.z);
  }

  ZVector operator +(ZVector v) => addVector(v);

  ZVector operator -(ZVector v) => subtractVector(v);

  ZVector operator *(ZVector v) => multiply(v);

  ZVector operator /(ZVector v) => multiply(v);

  /// Cross product.
  ZVector cross(ZVector other) {
    final double tx = x; //this
    final double ty = y;
    final double tz = z;
    final double ox = other.x;
    final double oy = other.y;
    final double oz = other.z;
    return ZVector.only(
      x: ty * oz - tz * oy,
      y: tz * ox - tx * oz,
      z: tx * oy - ty * ox,
    );
  }

  ZVector unit() {
    var total = magnitude();
    return ZVector(x / total, y / total, z / total);
  }

  @override
  String toString() {
    return 'V($x, $y, $z)';
  }
}
