import 'package:get/get.dart';
import '../Controllers/all_users_controller.dart';
import '../Data/interfaces/interfaces.dart';
import '../Data/repository/users_repository.dart';
import '../Data/services/users_services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<Interfaces>(() => FirebaseAuthServices());
    Get.lazyPut<Interfaces>(() => UsersServices());
    Get.lazyPut<UsersRepository>(
        () => UsersRepository(interfaces: Get.find<Interfaces>()));

    Get.lazyPut<AllUsersController>(
        () => AllUsersController(usersRepository: Get.find<UsersRepository>()));
  }
}
