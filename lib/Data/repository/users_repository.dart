import 'package:vav_foods_admin_app/Data/models/user_model.dart';

import '../interfaces/interfaces.dart';

class UsersRepository {
  final Interfaces interfaces;

  UsersRepository({required this.interfaces});
  Future<List<UserModel>> fetchUsersFromFirebase() async {
    return await interfaces.fetchUsersFromFirebase();
  }

  Future<UserModel?> fetchsingleUserFromFirebase(String userId) async {
    return await interfaces.fetchsingleUserFromFirebase(userId);
  }
}
