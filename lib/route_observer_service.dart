import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yatharthageeta/utils/utils.dart';

class RouteObserverService extends GetObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('\x1B[38;5;206m[Route Pushed] ${route.settings.name}\x1B[0m');
    // Utils.customToast("Route Pushed ${route.settings.name}", Colors.white,
    //     Colors.pink, "true");
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('\x1B[38;5;206m[Route Popped] ${route.settings.name}\x1B[0m');
    // Utils.customToast("Route Popped ${route.settings.name}", Colors.white,
    //     Colors.pink, "true");
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugPrint('\x1B[38;5;206m[Route Removed] ${route.settings.name}\x1B[0m');
    // Utils.customToast("Route Removed: ${route.settings.name}", Colors.white,
    //     Colors.pink, "true");
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint(
        '\x1B[38;5;206m[Route Replaced] ${newRoute?.settings.name}\x1B[0m');
    // Utils.customToast("Route Replaced ${newRoute?.settings.name}", Colors.white,
    //     Colors.pink, "true");
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
