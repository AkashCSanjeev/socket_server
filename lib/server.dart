import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

typedef Uint8ListCallback = Function(Uint8List data);
typedef DynamicCallback = Function(dynamic data);

class Server {
  Uint8ListCallback? onData;
  DynamicCallback? onError;
  Server(this.onData, this.onError);
  ServerSocket? server;
  bool running = false;
  List<Socket> sockets = [];

  Future<void> start() async {
    runZoned(() async {
      // CHECK FOR IP ADDRESS IN THE DEVICE YOU ARE USING IT IN
      server = await ServerSocket.bind("192.168.1.8", 6677);
      running = true;
      server!.listen(onRequest);
      final message = "server is listening on port 4000";
      onData!(Uint8List.fromList(message.codeUnits));
    }, onError: onError);
  }

  Future<void> close() async {
    await server!.close();
    server = null;
    running = false;
  }

  void onRequest(Socket socket) {
    if (!sockets.contains(socket)) {
      sockets.add(socket);
    }
    socket.listen((event) {
      onData!(event);
    });
  }

  void broadcast(String data) {
    onData!(Uint8List.fromList("Broadcast data : $data".codeUnits));
    for (var socket in sockets) {
      socket.write(data);
    }
  }
}
