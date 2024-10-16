import 'package:get/get.dart';
import '../Presentation/Admin/screens/add_user_screen.dart';
import '../Presentation/Admin/screens/all_users_screen.dart';
import '../Presentation/Admin/screens/main_screen.dart';
import '../Presentation/Admin/screens/single_user_details_screen.dart';

// Define your routes
class AppRoutes {
  static const String mainScreen = '/MainScreen';
  static const String allUsersScreen = '/AllusersScreen';
  static const String singleUserDetailsScreen = '/SingleUserDetailsScreen';
  static const String addUserScreen = '/AddUserScreen';

  static final List<GetPage> routes = [
    GetPage(name: mainScreen, page: () => const MainScreen()),
    GetPage(name: allUsersScreen, page: () => const AllUsersScreen()),
    GetPage(
        name: singleUserDetailsScreen, page: () => SingleUserDetailsScreen()),
    GetPage(name: addUserScreen, page: () => const AddUserScreen()),
  ];
}
