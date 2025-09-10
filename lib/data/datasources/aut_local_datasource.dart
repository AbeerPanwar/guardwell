import 'dart:convert';
import 'package:guardwell/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getLastUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();
  Future<bool> isUserCached();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const String cachedUser = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getLastUser() async {
    final jsonString = sharedPreferences.getString(cachedUser);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      cachedUser, 
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(cachedUser);
  }

  @override
  Future<bool> isUserCached() async {
    return sharedPreferences.containsKey(cachedUser);
  }
}