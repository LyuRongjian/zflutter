import 'package:flutter/material.dart';

import '../../zflutter.dart';

class ZGroup extends ZMultiChildWidget {
  final SortMode sortMode;
  ZGroup(
      {super.key, required super.children, this.sortMode = SortMode.inherit});

  @override
  RenderZMultiChildBox createRenderObject(BuildContext context) {
    return RenderZMultiChildBox(sortMode: sortMode);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderZMultiChildBox renderObject) {
    renderObject.sortMode = sortMode;
  }
}
