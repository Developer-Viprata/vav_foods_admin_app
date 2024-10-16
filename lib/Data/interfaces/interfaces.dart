import '../models/user_model.dart';

abstract class Interfaces {
  Future<List<UserModel>> fetchUsersFromFirebase();
  //fetching a single user by their userId
  Future<UserModel?> fetchsingleUserFromFirebase(String userId);
}
