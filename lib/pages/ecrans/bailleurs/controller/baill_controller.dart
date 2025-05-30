import 'package:get/get.dart';

class BaillController extends GetxController {
  static final BaillController instance = BaillController._internal();

  BaillController._internal();

  var _curentIndex = 0.obs;

  updateCurentIndex(value) => _curentIndex.value = value;

  get curentIndex => _curentIndex.value;
}
