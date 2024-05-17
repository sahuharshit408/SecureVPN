import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dialogs {

  static success({required String msg}) {
    Get.snackbar('Success' , msg ,
        colorText: Colors.white,
        backgroundColor: Colors.greenAccent.withOpacity(.5));
  }

  static error({required String msg}) {
    Get.snackbar('Error' , msg ,
        colorText: Colors.white,
        backgroundColor: Colors.redAccent.withOpacity(.5));
  }

  static info({required String msg}) {
    Get.snackbar('Info' , msg ,
        colorText: Colors.white ,
        backgroundColor: Colors.blueAccent.withOpacity(.5));
  }

  static showProgress() {
    Get.dialog(Center(child: CircularProgressIndicator(strokeWidth: 2)));
  }
}