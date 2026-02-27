import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/support/screens/support_screen.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';

class WebSupportScreen extends StatelessWidget {
  const WebSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(children: [
          WebScreenTitleWidget(title: 'help_support'.tr),

          Container(
            margin: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
            width: Dimensions.webMaxWidth,
            padding: EdgeInsets.all(Dimensions.paddingSizeExtraLarge * 2),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
            child: Row(children: [
              Expanded(child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraOverLarge, bottom: Dimensions.paddingSizeDefault),
                  child: CustomAssetImageWidget(Images.helpAndSupportBg, height: 120, width: 170),
                ),

                Text('contact_for_support'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Padding(padding: const EdgeInsets.symmetric(horizontal: 50), child: SizedBox(width: 380,
                  child: Text('contact_for_support_description'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                )),
                const SizedBox(height: 50),
              ])),

              Expanded(child: Container(
                width: Dimensions.webMaxWidth,
                padding: EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                decoration: BoxDecoration(color: Theme.of(context).disabledColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
                child: Column(children: [
                  SupportCard(
                    title: 'call_our_customer_support'.tr,
                    description: 'talk_with_our_customer_support_executive_at_any_time'.tr,
                    icon: Icons.phone,
                    contactInfo: Get.find<SplashController>().configModel?.phone ?? '',
                    onTap: () async {
                      if(await canLaunchUrlString('tel:${Get.find<SplashController>().configModel!.phone}')) {
                        launchUrlString('tel:${Get.find<SplashController>().configModel!.phone}', mode: LaunchMode.externalApplication);
                      }else {
                        showCustomSnackBar('${'can_not_launch'.tr} ${Get.find<SplashController>().configModel!.phone}');
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  SupportCard(
                    title: 'send_us_email_through'.tr,
                    description: 'typically_the_support_team_send_you_any_feedback_in_2_hours'.tr,
                    icon: Icons.email,
                    contactInfo: Get.find<SplashController>().configModel?.email ?? '',
                    onTap: () {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: Get.find<SplashController>().configModel!.email,
                      );
                      launchUrlString(emailLaunchUri.toString(), mode: LaunchMode.externalApplication);
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  SupportCard(
                    title: 'address'.tr,
                    description: Get.find<SplashController>().configModel?.address ?? '',
                    icon: Icons.location_on,
                    isAddress: true,
                  ),
                ]),
              )),
            ]),
          ),

        ]),
      ),
    );
  }
}

