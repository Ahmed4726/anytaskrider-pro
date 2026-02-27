import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class VerificationBottomSheet extends StatelessWidget {
  final bool isEmail;
  final Function()? onTap;
  const VerificationBottomSheet({super.key, this.isEmail = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Container(
          height: 5, width: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
        ),

        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.close, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
          ),
        ),

        Image.asset(
          Images.verificationIcon, height: 60, width: 60,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Text(
            isEmail ? 'verify_your_email'.tr : 'verify_your_phone_number'.tr,
            style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Text(
            isEmail ? 'we_will_send_you_a_one_time_code_to_confirm_your_email'.tr : 'we_will_send_you_a_one_time_code_to_confirm_your_phone_number'.tr,
            style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 50),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Row(children: [
            Expanded(
              child: CustomButtonWidget(
                isBold: false,
                fontSize: Dimensions.fontSizeDefault,
                onPressed: () {
                  Get.back();
                },
                buttonText: 'cancel'.tr,
                color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                textColor: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(
              child: CustomButtonWidget(
                isBold: false,
                fontSize: Dimensions.fontSizeDefault,
                onPressed: onTap,
                buttonText: 'continue'.tr,
              ),
            ),

          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ]),

    );
  }
}
