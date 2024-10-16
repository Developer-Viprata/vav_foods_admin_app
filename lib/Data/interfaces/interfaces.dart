import '../models/user_model.dart';

abstract class Interfaces {
  // Fetch all users from Firebase
  Future<List<UserModel>> fetchUsersFromFirebase();

  // Fetch a single user by their userId
  Future<UserModel?> fetchsingleUserFromFirebase(String userId);

  // Add a new user to Firebase with provided details
  Future<List<UserModel>> addUsersToFirebase(
    String fullName,
    String email,
    String phoneNumber,
    String password,
    UserRole role,
  );

  Future<List<UserModel>> deleteUser(String userId);
}
