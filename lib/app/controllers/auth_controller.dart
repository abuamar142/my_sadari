import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/user_model.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  var user = Rxn<User>();
  final box = GetStorage();

  void setUser(User newUser) {
    user.value = newUser;
    box.write('user', newUser.toJson());
  }

  void clearUser() {
    user.value = null;
    box.remove('user');
    box.remove('token');
  }

  void autoLogin() {
    final userData = box.read('user');
    // if (kDebugMode) {
    //   print('autoLogin: userData from storage: $userData');
    // }
    if (userData != null) {
      user.value = User.fromJson(Map<String, dynamic>.from(userData));
      // if (kDebugMode) {
      //   print('autoLogin: user.value set to: ${user.value?.toJson()}');
      // }
    } else {
      // if (kDebugMode) {
      //   print('autoLogin: No user data found in storage');
      // }
    }
  }

  String? get token => box.read('token');
}
