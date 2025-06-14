import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_routes.dart';

import '../../domain/entities/enum.dart';
import 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final String noInternetRoute;
  final GoRouter router;

  NetworkCubit({
    required this.router,
    this.noInternetRoute = AppRoutes.networkError
  }) : super(NetworkState.initial()) {
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      debugPrint('Could not check connectivity status: $e');
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (isClosed) return;
    final currentLocation =
        router.routerDelegate.currentConfiguration.uri.toString();

    if (result.first == ConnectivityResult.none) {
      if (state.status == NetworkConnectionStatus.online &&
          currentLocation != noInternetRoute) {
        if (!isClosed) {
          emit(state.copyWith(
            status: NetworkConnectionStatus.offline,
            lastOnlineRoute: currentLocation,
          ));
        }
        router.go(noInternetRoute);
      } else if (state.status != NetworkConnectionStatus.offline) {
        if (!isClosed) {
          emit(state.copyWith(status: NetworkConnectionStatus.offline));
        }
      }
    } else {
      if (state.status == NetworkConnectionStatus.offline) {
        if (!isClosed) {
          emit(state.copyWith(status: NetworkConnectionStatus.online));
        }
        if (currentLocation == noInternetRoute &&
            state.lastOnlineRoute != null) {
          router.go(state.lastOnlineRoute!);
        }
      } else if (state.status != NetworkConnectionStatus.online) {
        if (!isClosed) {
          emit(state.copyWith(status: NetworkConnectionStatus.online));
        }
      }
    }
  }

  void checkConnectivity() {
    _initConnectivity();
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription.cancel();
    return super.close();
  }
}
