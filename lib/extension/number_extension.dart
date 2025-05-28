import 'package:flutter/material.dart';

extension NumberExtension on num {
  num pcw(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    return (this * width) / 100;
  }

  num pch(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    return (this * height) / 100;
  }

  // num w(BuildContext context) {
  //   return this *
  //       (MediaQuery.of(context).size.width /
  //           MediaQuery.of(context).devicePixelRatio);
  // }

  // num h(BuildContext context) {
  //   return this *
  //       (MediaQuery.of(context).size.height /
  //           MediaQuery.of(context).devicePixelRatio);
  // }
}
