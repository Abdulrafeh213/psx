import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      isLoading.value = false;
      Get.offNamed('/authentication');
    });
  }
}
