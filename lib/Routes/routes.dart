import 'package:get/get.dart';
import 'package:vav_foods_admin_app/Presentation/Admin/screens/all_users_screen.dart';

import '../Presentation/Admin/screens/main_screen.dart';

// Define your routes
class AppRoutes {
  static const String splashScreen = '/';
  static const String welcomeScreen = '/WelcomeScreen';
  static const String signupScreen = '/SignupScren';
  static const String loginScreen = '/LoginScreen';
  static const String forgotPasswordScreen = '/ForgotPasswordScreen';
  static const String mainScreen = '/MainScreen';
  static const String allUsersScreen = '/AllusersScreen';

  static final List<GetPage> routes = [
    /*   GetPage(name: splashScreen, page: () => const SignupScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(
        name: forgotPasswordScreen, page: () => const ForgotPasswordScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()), */
    GetPage(name: mainScreen, page: () => const MainScreen()),
    GetPage(name: allUsersScreen, page: () => const AllUsersScreen()),
  ];
}
