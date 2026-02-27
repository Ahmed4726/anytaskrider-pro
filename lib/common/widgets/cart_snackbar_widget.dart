import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCartSnackBarWidget() {
  Get.snackbar(
    '',
    'item_added_to_cart'.tr,
    titleText: const SizedBox.shrink(),
    backgroundColor: Colors.green,
    colorText: Colors.white,
    messageText: Text(
      'item_added_to_cart'.tr,
      style: robotoMedium.copyWith(color: Colors.white),
    ),
    snackPosition: SnackPosition.BOTTOM,
    margin: ResponsiveHelper.isDesktop(Get.context) ? EdgeInsets.only(
      right: Get.context!.width * 0.7,
      left: Dimensions.paddingSizeSmall,
      bottom: Dimensions.paddingSizeSmall,
    ) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
    duration: const Duration(seconds: 3),
    borderRadius: Dimensions.radiusSmall,
    isDismissible: true,
    mainButton: TextButton(
      onPressed: () {
        Get.back();
        Get.toNamed(RouteHelper.getCartRoute());
      },
      child: Text('view_cart'.tr, style: const TextStyle(color: Colors.white)),
    ),
  );
}