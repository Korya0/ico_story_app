import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

MaterialPage<dynamic> naturalTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return MaterialPage<dynamic>(
    key: state.pageKey,
    child: child,
  );
}
