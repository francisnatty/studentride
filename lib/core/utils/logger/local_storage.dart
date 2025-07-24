// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalStorage {
  FlutterSecureStorage storage;
  LocalStorage({required this.storage});
  Future<void> saveAcessToken(String value);
  Future<void> saveRefreshToken(String value);
  // Future<void> saveLoginResponse(LoginResponse loginRes);
  Future<void> saveSubscriptionId(String value);

  Future<String?> getAcessToken();
  Future<String?> getRefreshToken();
  //  Future<LoginResponse?> getLoginResponse();
  Future<String?> getSubscriptionId();

  Future<void> clearAllData();
}

class LocalStorageImpl implements LocalStorage {
  @override
  Future<void> clearAllData() async {
    await storage.deleteAll();
  }

  @override
  Future<void> saveAcessToken(String value) async {
    await storage.write(key: accessTokenKey, value: value);
  }

  @override
  Future<void> saveRefreshToken(String value) async {
    await storage.write(key: refreshTokenKey, value: value);
  }

  @override
  Future<String?> getAcessToken() async {
    return await storage.read(key: accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await storage.read(key: refreshTokenKey);
  }

  @override
  FlutterSecureStorage storage = const FlutterSecureStorage();

  // @override
  // Future<LoginResponse?> getLoginResponse() async {
  //   String? jsonString = await storage.read(key: loginKey);

  //   if (jsonString == null) return null; // 🔐 Safe null check

  //   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  //   return LoginResponse.fromJson(jsonMap);
  // }

  // @override
  // Future<void> saveLoginResponse(LoginResponse loginRes) async {
  //   String jsonString = jsonEncode(loginRes.toJson());
  //   await storage.write(key: loginKey, value: jsonString);
  // }

  @override
  Future<String?> getSubscriptionId() async {
    return await storage.read(key: subscriptionKey);
  }

  @override
  Future<void> saveSubscriptionId(String value) async {
    await storage.write(key: subscriptionKey, value: value);
  }
}

String accessTokenKey = 'access_token';
String refreshTokenKey = 'refresh_token';
String loginKey = 'login_response';
String profileKey = 'profile';
String subscriptionKey = 'notification_subscriptionId';
