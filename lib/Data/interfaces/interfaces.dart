import '../models/user_model.dart';

abstract class Interfaces {
  Future<List<UserModel>> fetchUsersFromFirebase();
}
