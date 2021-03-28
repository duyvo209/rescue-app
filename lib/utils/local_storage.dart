import 'package:rescue/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final storage = new FlutterSecureStorage();

  Future<void> setUserPass(String user, String pass) async {
    await storage.write(key: Constants.USER_NAME, value: user);
    await storage.write(key: Constants.PASSWORD, value: pass);
  }

  Future<Map<String, dynamic>> getUserPass() async {
    var user = await storage.read(key: Constants.USER_NAME);
    var pass = await storage.read(key: Constants.PASSWORD);
    return {
      'user': user,
      'pass': pass,
    };
  }

  Future<void> setLoginMethod(String method) async {
    await storage.write(key: Constants.LOGIN_METHOD, value: method);
  }

  Future<String> getLoginMethod() async {
    return storage.read(key: Constants.LOGIN_METHOD);
  }

  Future<void> deleteUserData() async {
    await storage.delete(key: Constants.USER_NAME);
    await storage.delete(key: Constants.PASSWORD);
    await storage.delete(key: Constants.LOGIN_METHOD);
  }
}
