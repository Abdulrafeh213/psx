import 'package:get/get.dart';

import '../modules/adminDashboard/bindings/admin_dashboard_binding.dart';
import '../modules/adminDashboard/views/admin_dashboard_view.dart';
import '../modules/ads/bindings/ads_binding.dart';
import '../modules/ads/views/ads_view.dart';
import '../modules/authentication/bindings/authentication_binding.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/authentication/views/login/login_email_view.dart';
import '../modules/authentication/views/login/login_phone_view.dart';
import '../modules/authentication/views/otp_verification_view.dart';
import '../modules/authentication/views/singup/singup_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/chats/bindings/chats_binding.dart';
import '../modules/chats/views/chats_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/products/bindings/products_binding.dart';
import '../modules/products/views/products_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/sell/bindings/sell_binding.dart';
import '../modules/sell/views/sell_view.dart';
import '../modules/splashScreen/bindings/splash_screen_binding.dart';
import '../modules/splashScreen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splashScreen;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: _Paths.authentication,
      page: () => const AuthenticationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.splashScreen,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.chats,
      page: () => const ChatsView(),
      binding: ChatsBinding(),
    ),
    GetPage(
      name: _Paths.sell,
      page: () => const SellView(),
      binding: SellBinding(),
    ),
    GetPage(
      name: _Paths.ads,
      page: () => const AdsView(),
      binding: AdsBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.products,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.adminDashboard,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.payment,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),

    //authentication pages
    GetPage(
      name: _Paths.loginEmail,
      page: () => const LoginEmailView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.loginPhone,
      page: () => const LoginPhoneView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.singupEmail,
      page: () => SingupView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.otpVerification,
      page: () => const OtpVerificationView(),
      binding: AuthenticationBinding(),
    ),
  ];
}
