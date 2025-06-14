import 'package:flutter/material.dart';

class AppLifecycleUtil {
  static AppLifecycleUtil? _instance;
  static bool _hasTriggeredOnResume = false;

  AppLifecycleUtil._internal();

  static AppLifecycleUtil get instance {
    _instance ??= AppLifecycleUtil._internal();
    return _instance!;
  }

  void listen({
    VoidCallback? onResume,
    VoidCallback? onPause,
    VoidCallback? onInactive,
    VoidCallback? onDetached,
  }) {
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        onResume: () {
          if (!_hasTriggeredOnResume) {
            _hasTriggeredOnResume = true;
            onResume?.call();
          }
        },
        onPause: onPause,
        onInactive: onInactive,
        onDetached: onDetached,
      ),
    );
  }

  void resetOnResume() {
    _hasTriggeredOnResume = false;
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final VoidCallback? onResume;
  final VoidCallback? onPause;
  final VoidCallback? onInactive;
  final VoidCallback? onDetached;
  final VoidCallback? onHidden;

  LifecycleEventHandler(
      {this.onResume, this.onPause, this.onInactive, this.onDetached,this.onHidden,});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume?.call();
        break;
      case AppLifecycleState.paused:
        onPause?.call();
        break;
      case AppLifecycleState.inactive:
        onInactive?.call();
        break;
      case AppLifecycleState.detached:
        onDetached?.call();
        break;
      case AppLifecycleState.hidden:
        onHidden?.call();
        break;
    }
  }
}
