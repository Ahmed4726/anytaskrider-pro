import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class AccountDeletionBottomSheet extends StatelessWidget {
  final ProfileController profileController;
  final bool isRunningOrderAvailable;
  const AccountDeletionBottomSheet({super.key, required this.profileController, this.isRunningOrderAvailable = false});

  @override
  Widget build(BuildContext context) {
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

        CustomAssetImageWidget(
          Images.deleteIcon,
          height: 60, width: 60, fit: BoxFit.cover,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(isRunningOrderAvailable ? 'you_cant_delete_your_account_yet'.tr : 'delete_your_account'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            isRunningOrderAvailable ? 'please_complete_your_ongoing_and_accepted_orders'.tr : 'you_will_not_be_able_to_recover_your_data_again'.tr,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 50),

        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: isRunningOrderAvailable ? CustomButtonWidget(
            width: 170,
            buttonText: 'view_orders'.tr,
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeDefault,
            onPressed: () {
              Get.back();
              Get.toNamed(RouteHelper.getOrderRoute());
            },
          ) : GetBuilder<ProfileController>(builder: (pController) {
            return pController.isLoading ? const Center(child: CircularProgressIndicator()) : Row(children: [
              Expanded(child: CustomButtonWidget(
                buttonText: 'cancel'.tr,
                color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                fontSize: Dimensions.fontSizeDefault,
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
                onPressed: () => Get.back(),
              )),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(child: CustomButtonWidget(
                buttonText: 'remove'.tr,
                color: Theme.of(context).colorScheme.error,
                fontSize: Dimensions.fontSizeDefault,
                isLoading: pController.isLoading,
                onPressed: () => pController.removeUser(),
              )),
            ]);
          }),
        ),

      ]),

    );
  }
}
