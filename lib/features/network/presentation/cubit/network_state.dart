
import '../../domain/entities/enum.dart';

class NetworkState {
  final NetworkConnectionStatus status;
  final String? lastOnlineRoute;

  NetworkState({
    required this.status,
    this.lastOnlineRoute,
  });

  factory NetworkState.initial() =>
      NetworkState(status: NetworkConnectionStatus.online);

  NetworkState copyWith({
    NetworkConnectionStatus? status,
    String? lastOnlineRoute,
  }) {
    return NetworkState(
      status: status ?? this.status,
      lastOnlineRoute: lastOnlineRoute ?? this.lastOnlineRoute,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          lastOnlineRoute == other.lastOnlineRoute;

  @override
  int get hashCode => status.hashCode ^ lastOnlineRoute.hashCode;
}
