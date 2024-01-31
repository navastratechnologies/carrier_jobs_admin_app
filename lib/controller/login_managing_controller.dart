import 'package:flutter_secure_storage/flutter_secure_storage.dart';

FlutterSecureStorage storage = const FlutterSecureStorage();

void storeLogin(username) async {
  await storage.write(key: "token", value: username.toString());
}

Future<String?> getToken() async {
  return await storage.read(key: "token");
}
