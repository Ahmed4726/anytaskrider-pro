import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/support/widgets/web_support_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBarWidget(title: 'help_and_support'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: isDesktop ? Center(
        child: SingleChildScrollView(
          child: const FooterViewWidget(child: SizedBox(width: double.infinity, child: WebSupportScreen())),
        )) : SingleChildScrollView(
          child: Column(children: [

            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraOverLarge, bottom: Dimensions.paddingSizeDefault),
              child: CustomAssetImageWidget(
                Images.helpAndSupportBg,
                height: 120, width: 170,
              ),
            ),

            Text('contact_for_support'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'contact_for_support_description'.tr,
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ),
            ),
            const SizedBox(height: 50),

            Container(
              padding: EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.02),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.paddingSizeExtraOverLarge),
                  topRight: Radius.circular(Dimensions.paddingSizeExtraOverLarge),
                ),
              ),
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
                    }
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
            ),

          ]),
        ),
    );
  }
}

class SupportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? contactInfo;
  final Function()? onTap;
  final bool isAddress;
  const SupportCard({super.key, required this.title, required this.description, required this.icon, this.contactInfo, this.onTap, this.isAddress = false});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
      borderRadius: Dimensions.radiusDefault,
      child: InkWell(
        onTap: onTap,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            ),
            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          ),
          SizedBox(width: Dimensions.paddingSizeDefault),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
              SizedBox(height: Dimensions.paddingSizeExtraSmall),

              isAddress ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Text(
                    description,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                  ),
                ),
                SizedBox(width: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Icon(icon, color: Theme.of(context).cardColor),
                ),
              ]) : Text(
                description,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ),
              SizedBox(height: Dimensions.paddingSizeSmall),

              !isAddress ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: Text(
                    contactInfo ?? '',
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                  ),
                ),
                SizedBox(width: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Icon(icon, color: Theme.of(context).cardColor),
                ),
              ]) : SizedBox(),
            ]),
          ),

        ]),
      ),
    );
  }
}
