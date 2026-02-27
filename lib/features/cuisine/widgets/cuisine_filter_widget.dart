import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../controllers/cuisine_controller.dart';

class CuisineFilterWidget extends StatelessWidget {
  const CuisineFilterWidget({super.key, required this.cuisineId});
  final int cuisineId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(
      builder: (cuisineController) {return PopupMenuButton(
        itemBuilder: (context) {return [
            PopupMenuItem(
              value: 'take_away',
              child: Text(
                'take_away'.tr,
                style: robotoMedium.copyWith(color: cuisineController.filterType == 'take_away' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor),
              ),
            ),
            PopupMenuItem(
              value: 'delivery',
              child: Text(
                'delivery'.tr,
                style: robotoMedium.copyWith(color: cuisineController.filterType == 'delivery' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor),
              ),
            ),
            PopupMenuItem(
              value: 'dine_in',
              child: Text(
                'dine_in'.tr,
                style: robotoMedium.copyWith(color: cuisineController.filterType == 'dine_in' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor),
              ),
            ),
            PopupMenuItem(
              value: 'latest',
              child: Text(
                'latest'.tr,
                style: robotoMedium.copyWith(color: cuisineController.filterType == 'latest' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor),
              ),
            ),
            PopupMenuItem(
              value: 'popular',
              child: Text(
                'popular'.tr,
                style: robotoMedium.copyWith(color: cuisineController.filterType == 'popular' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor),
              ),
            )];},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: Image.asset(Images.filterIcon, width: 20),
        onSelected: (dynamic value) {
          cuisineController.setFilterType(value);
          cuisineController.getCuisineRestaurantList(cuisineId, 1, true);
        },
      );
    });
  }
}