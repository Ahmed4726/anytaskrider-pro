import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class ClearAllBottomSheet extends StatelessWidget {
  final bool isFood;
  const ClearAllBottomSheet({super.key, this.isFood = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavouriteController>(builder: (favouriteController) {
      return Container(
        width: ResponsiveHelper.isDesktop(context) ? 500 : context.width,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          ResponsiveHelper.isDesktop(context) ? const SizedBox() : Container(
            height: 5, width: 35,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),

          ClipOval(child: CustomAssetImageWidget(
            Images.warningIcon,
            height: 70, width: 70, fit: BoxFit.cover,
          )),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text('clear_all_favourites'.tr,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'are_you_sure_you_want_to_clear_all_favourites'.tr,
              style: robotoRegular, textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(children: [

            Expanded(child: CustomButtonWidget(
              buttonText: 'cancel'.tr,
              height: 40,
              color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
              fontSize: Dimensions.fontSizeDefault,
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () => Get.back(),
            )),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(child: CustomButtonWidget(
              buttonText: 'clear_all'.tr,
              height: 40,
              color: Theme.of(context).colorScheme.error,
              fontSize: Dimensions.fontSizeDefault,
              isLoading: favouriteController.isLoading,
              onPressed: () => favouriteController.clearAll(isFood: isFood),
            )),

          ]),

        ]),

      );
    });
  }
}
