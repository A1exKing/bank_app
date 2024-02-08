import 'package:get/get.dart';

class UserController extends GetxController {
  var _userId = ''.obs;

  String get userId => _userId.value;

  set userId(String value) => _userId.value = value;
}
