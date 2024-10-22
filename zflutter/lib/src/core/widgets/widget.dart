import 'package:flutter/material.dart';
import 'update_parent_data.dart';

import '../core.dart';

mixin ZWidget on Widget {}

class ZSingleChildRenderObjectElement extends SingleChildRenderObjectElement {
  ZSingleChildRenderObjectElement(super.widget);

  @override
  void attachRenderObject(newSlot) {
    super.attachRenderObject(newSlot);

    visitAncestorElements((element) {
      if (element is UpdateParentDataElement<ZParentData>) {
        element.startParentData(renderObject, element.transform);
      }
      return element.widget is! RenderObjectWidget;
    });
  }
}

abstract class ZMultiChildWidget extends MultiChildRenderObjectWidget
    with ZWidget {
  ZMultiChildWidget({super.key, required super.children});

  @override
  RenderZMultiChildBox createRenderObject(BuildContext context) {
    return RenderZMultiChildBox();
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderZMultiChildBox renderObject) {}

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  /* properties.add(EnumProperty<AxisDirection>('axisDirection', axisDirection));
   properties.add(EnumProperty<AxisDirection>('crossAxisDirection', crossAxisDirection, defaultValue: null));
   properties.add(DiagnosticsProperty<ViewportOffset>('offset', offset));*/
  // }

  @override
  AnchorMultipleChildRenderObjectElement createElement() =>
      AnchorMultipleChildRenderObjectElement(this);
}

class AnchorMultipleChildRenderObjectElement
    extends MultiChildRenderObjectElement {
  /// Creates an element that uses the given widget as its configuration.
  AnchorMultipleChildRenderObjectElement(super.widget)
      : assert(!debugChildrenHaveDuplicateKeys(widget, widget.children));

  @override
  void attachRenderObject(newSlot) {
    super.attachRenderObject(newSlot);

    visitAncestorElements((element) {
      if (element is UpdateParentDataElement<ZParentData>) {
        element.startParentData(renderObject, element.transform);
      }
      return element.widget is! RenderObjectWidget;
    });
  }
}
