import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic>? push(Route<dynamic> route) {
    return navigatorKey.currentState?.push(route);
  }

  Future<dynamic>? pushReplacement(Route<dynamic> route) {
    return navigatorKey.currentState?.pushReplacement(route);
  }

  Future<dynamic>? pushAndRemoveUntil(Route<dynamic> route) {
    return navigatorKey.currentState?.pushAndRemoveUntil(
      route,
      (route) => false,
    );
  }

  void goBack() {
    return navigatorKey.currentState?.pop();
  }
}
