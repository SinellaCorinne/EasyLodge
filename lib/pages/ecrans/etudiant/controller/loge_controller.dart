import 'package:get/get.dart';

class LogeController extends GetxController {
  static final LogeController instance = LogeController._internal();

 LogeController._internal();

  var _curentIndex = 0.obs;

  updateCurentIndex(value) => _curentIndex.value = value;

  get curentIndex => _curentIndex.value;
}
