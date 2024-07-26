import 'package:book_app/Pages/HomePage/HomePage.dart';
import 'package:book_app/Pages/HomePage/HomePage.dart';
import 'package:book_app/Pages/WelcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplaceController extends GetxController {
  final auth = FirebaseAuth.instance;
  @override
  void onInit() {
    splaceController();
  }

  void splaceController() {
    Future.delayed(Duration(seconds: 7), () {
      if (auth.currentUser != null) {
        Get.offAll(Homepage());
      } else {
        Get.offAll(Homepage());
      }
    });
  }
}
