import 'package:get/get.dart';
import 'package:paksecureexchange/app/modules/authentication/views/location_view.dart';

import '../modules/adminDashboard/bindings/admin_dashboard_binding.dart';
import '../modules/adminDashboard/views/admin_chats_view.dart';
import '../modules/adminDashboard/views/admin_dashboard_view.dart';
import '../modules/adminDashboard/views/ads_view.dart';
import '../modules/adminDashboard/views/users_view.dart';
import '../modules/adminDashboard/views/widgets/profile_setting_view.dart';
import '../modules/adminDashboard/views/widgets/show_categories.dart';
import '../modules/ads/bindings/ads_binding.dart';
import '../modules/ads/views/ads_view.dart';
import '../modules/authentication/bindings/authentication_binding.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/authentication/views/login/forgot_password.dart';
import '../modules/authentication/views/login/login_email_view.dart';
import '../modules/authentication/views/login/login_otp_verification_view.dart';
import '../modules/authentication/views/login/login_phone_view.dart';
import '../modules/authentication/views/singup/email_verification_view.dart';
import '../modules/authentication/views/singup/personal_details_view.dart';
import '../modules/authentication/views/singup/singup_otp_verification_view.dart';
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
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/help_and_support_view.dart';
import '../modules/profile/views/my_shop_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/setting_view.dart';
import '../modules/sell/bindings/sell_binding.dart';
import '../modules/sell/views/sell_view.dart';
import '../modules/splashScreen/bindings/splash_screen_binding.dart';
import '../modules/splashScreen/views/splash_screen_view.dart';
import '../modules/adminDashboard/views/category_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splashScreen;

  static final routes = [
    GetPage(name: _Paths.home, page: () => HomeView(), binding: HomeBinding()),

    GetPage(
      name: _Paths.authentication,
      page: () => AuthenticationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.splashScreen,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.chats,
      page: () => ChatsView(),
      binding: ChatsBinding(),
    ),
    GetPage(
      name: _Paths.sell,
      page: () => SellView(),
      binding: SellBinding(),
    ),
    GetPage(
      name: _Paths.ads,
      page: () => AdsView(),
      binding: AdsBinding(),
    ),
   GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.products,
      page: () => ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.adminDashboard,
      page: () => AdminDashboardView(),
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
      page: () => LoginEmailView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.loginPhone,
      page: () => LoginPhoneView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.singupEmail,
      page: () => SignupView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.loginOtpVerification,
      page: () => LoginOtpVerificationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.signupOtpVerifications,
      page: () => SignupOtpVerificationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.location,
      page: () => LocationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.categoryForm,
      page: () => CategoryFormView(),
      binding: AdminDashboardBinding(),
    ),

    // GetPage(
    //   name: _Paths.adminCategoriesView,
    //   page: () => AdminCategoriesView(),
    //   binding: AdminDashboardBinding(),
    // ),
    GetPage(
      name: _Paths.passwordForget,
      page: () => PasswordForget(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.editProfile,
      page: () => EditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.helpAndSupport,
      page: () => HelpAndSupportView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.myShop,
      page: () => MyShopView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.userSettings,
      page: () => SettingView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.adminChat,
      page: () => AdminChatsView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.adminAds,
      page: () => AdminAdsView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.adminUsersView,
      page: () => UsersView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.adminProfile,
      page: () => ProfileSettingView(),
      binding: AdminDashboardBinding(),
    ),

    GetPage(
      name: _Paths.emailVerify,
      page: () => EmailVerificationView(),
      binding: AuthenticationBinding(),
    ),

    GetPage(
      name: _Paths.personalDetailsView,
      page: () => PersonalDetailsView(),
      binding: AuthenticationBinding(),
    ),
  ];
}
