import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart'
    as io;

import '../config/env_config.dart';
import '../utils/app_logger.dart';

part 'socket_service.g.dart';

/// Uygulama genelinde tek Socket.io bağlantısını yönetir. Feature'lara
/// ait değil — core altında, çünkü mesajlaşma dışında ileride başka
/// modüller de (bildirimler vb.) aynı soket bağlantısını kullanabilir.
class SocketService {
  io.Socket? _socket;
  final _newMessageController =
      StreamController<
        Map<String, dynamic>
      >.broadcast();

  Stream<Map<String, dynamic>> get onNewMessage =>
      _newMessageController.stream;

  bool get isConnected =>
      _socket?.connected ?? false;

  void connect(int userId) {
    try {
      if (_socket != null && _socket!.connected)
        return;

      _socket = io.io(
        EnvConfig.socketBaseUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      _socket!.onConnect((_) {
        AppLogger.info(
          'SocketService - connect',
          'Bağlandı, oda katılımı: $userId',
        );
        _socket!.emit('join_own_room', userId);
      });

      _socket!.on('new_message', (data) {
        try {
          _newMessageController.add(
            Map<String, dynamic>.from(
              data as Map,
            ),
          );
        } catch (error, stackTrace) {
          AppLogger.error(
            'SocketService - new_message listener',
            error,
            stackTrace,
          );
        }
      });

      _socket!.onDisconnect(
        (_) => AppLogger.info(
          'SocketService - disconnect',
          'Bağlantı kesildi',
        ),
      );
      _socket!.onConnectError(
        (error) => AppLogger.error(
          'SocketService - onConnectError',
          error,
        ),
      );

      _socket!.connect();
    } catch (error, stackTrace) {
      AppLogger.error(
        'SocketService - connect',
        error,
        stackTrace,
      );
    }
  }

  void disconnect() {
    try {
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
    } catch (error, stackTrace) {
      AppLogger.error(
        'SocketService - disconnect',
        error,
        stackTrace,
      );
    }
  }
}

@Riverpod(keepAlive: true)
SocketService socketService(
  SocketServiceRef ref,
) {
  final service = SocketService();
  ref.onDispose(service.disconnect);
  return service;
}
