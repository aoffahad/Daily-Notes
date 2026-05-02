import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  var isFirstLaunch = true.obs;

  @override
  void onInit() {
    checkFirstLaunch();
    super.onInit();
  }

  Future<void> checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstLaunch.value = prefs.getBool('first_launch') ?? true;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    isFirstLaunch.value = false;
  }
}