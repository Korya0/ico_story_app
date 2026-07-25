import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class AppAnimations {
  static Widget fadeInUp(Widget child, {Duration? duration, Duration? delay}) {
    return FadeInUp(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget fadeInDown(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInDown(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget fadeInLeft(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInLeft(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget fadeInRight(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInRight(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget slideInUp(Widget child, {Duration? duration, Duration? delay}) {
    return SlideInUp(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget slideInDown(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return SlideInDown(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget slideInRight(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return SlideInRight(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }
}
