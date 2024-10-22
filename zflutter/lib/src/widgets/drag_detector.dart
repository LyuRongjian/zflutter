import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../zflutter.dart';
import '../core/core.dart';

typedef DragWidgetBuilder = Widget Function(
    BuildContext context, ZDragController controller);

class ZDragDetector extends StatefulWidget {
  final DragWidgetBuilder builder;

  const ZDragDetector({super.key, required this.builder});

  @override
  State<StatefulWidget> createState() => _ZDragDetectorState();
}

class _ZDragDetectorState extends State<ZDragDetector> {
  late ZDragController controller;
  Offset dragStart = Offset.zero;
  Offset dragStartR = Offset.zero;

  @override
  void initState() {
    controller = ZDragController(ZVector.zero);
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanStart: (event) {
          dragStartR = Offset(
            controller.rotate.x,
            controller.rotate.y,
          );
          dragStart = Offset(event.localPosition.dx, event.localPosition.dy);
        },
        onPanUpdate: (event) {
          var moveX = event.localPosition.dx - dragStart.dx;
          var moveY = event.localPosition.dy - dragStart.dy;

          var displaySize = MediaQuery.of(context).size;
          var minSize = min(displaySize.width, displaySize.height);
          var moveRY = moveX / minSize * tau;
          var moveRX = moveY / minSize * tau;
          controller._rotate = ZVector.only(
            x: dragStartR.dx - moveRX,
            y: dragStartR.dy - moveRY,
          );
        },
        child: widget.builder(
          context,
          controller,
        ));
  }

  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }
}

class ZDragController extends ValueNotifier<ZVector> {
  ZDragController(super.value);

  ZVector get rotate => value;

  set _rotate(ZVector rotate) {
    value = rotate;
  }
}
