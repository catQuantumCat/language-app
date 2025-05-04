import 'package:language_app/data/models/login_model.dart';
import 'package:language_app/data/models/register_model.dart';
import 'package:language_app/domain/dto/user_dto.dart';
import 'package:language_app/domain/models/user.dart';

abstract class UserRepo {
  //Login
  Future<User> login({required LoginModel data});

  //register
  Future<User> register({required RegisterModel data});

  //remove token and user info
  Future<void> logout();

  //get token
  Future<String?> getToken();

  //get token stream
  Future<Stream<String?>> getTokenStream();

  //set token
  Future<void> setToken({String? token});


  //get user info
  Future<User?> getUserInfo();

  Future<Stream<User?>> getUserInfoStream();

  //set user info
  Future<void> setUserInfo({required User data});

  Future<void> editUserInfo({required UserDTO data});
}
