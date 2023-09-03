import 'dart:typed_data';

import 'package:comm/server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class ServerController extends GetxController {
  Server? server;
  List<String> serverLogs = [];
  TextEditingController messageController = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    server = Server(OnData, onError);
    startOrStopServer();
    super.onInit();
  }

  Future<void> startOrStopServer() async {
    if (server!.running) {
      await server!.close();
      serverLogs.clear();
    } else {
      await server!.start();
    }
    update();
  }

  void OnData(Uint8List data) {
    String receviedData = String.fromCharCodes(data);
    serverLogs.add(receviedData);
    update();
  }

  void onError(dynamic error) {
    debugPrint("Error: $error");
  }

  void handleMessage() {
    server!.broadcast(messageController.text);
    serverLogs.add(messageController.text);
    update();
  }
}
