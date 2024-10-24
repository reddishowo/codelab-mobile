import 'package:codelab/app/modules/register/views/register_view.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const REGISTER = Routes.REGISTER;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
        GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterPage(),
    ),
  ];
}
