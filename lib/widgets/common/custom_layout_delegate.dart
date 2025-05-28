import 'package:flutter/material.dart';

class CustomLayoutDelegate extends MultiChildLayoutDelegate {
  final List<LayoutId> layoutChildren;

  CustomLayoutDelegate({required this.layoutChildren});
  @override
  void performLayout(Size size) {
    double xOffset = 0.0;
    for (int i = 0; i < layoutChildren.length; i++) {
      final childId = layoutChildren[i];
      if (hasChild(childId)) {
        final child = layoutChild(childId, BoxConstraints.loose(size));
        const childWidth = 200.0; // Set the width as needed
        final childHeight =
            layoutChild(childId, BoxConstraints.loose(size)).height;
        layoutChild(
            childId, BoxConstraints.tight(Size(childWidth, childHeight)));
        positionChild(childId, Offset(xOffset, 0.0));
        xOffset += childWidth; // Adjust for spacing or margin
      }
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
