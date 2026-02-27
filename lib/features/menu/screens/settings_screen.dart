import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/language/widgets/language_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/profile/widgets/notification_status_change_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'settings'.tr),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(children: [

          GetBuilder<ThemeController>(builder: (themeController) {
            return SettingsButton(
              icon: Icons.dark_mode, title: 'dark_mode'.tr,
              isButtonActive: themeController.darkTheme,
              onTap: () {
                themeController.toggleTheme();
              },
            );
          }),
          SizedBox(height: Dimensions.paddingSizeSmall),

          isLoggedIn ? GetBuilder<AuthController>(builder: (authController) {
            return SettingsButton(
              icon: Icons.notifications, title: 'notification'.tr,
              isButtonActive: authController.notification,
              onTap: () {
                Get.bottomSheet(const NotificationStatusChangeBottomSheet());
              },
            );
          }) : const SizedBox(),
          SizedBox(height: isLoggedIn ? Dimensions.paddingSizeSmall : 0),

          isLoggedIn ? SettingsButton(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
            Get.toNamed(RouteHelper.getResetPasswordRoute(phone: '', email: '', token: '', page: 'password-change'));
          }) : const SizedBox(),
          SizedBox(height: isLoggedIn ? Dimensions.paddingSizeSmall : 0),

          SettingsButton(
            icon: Icons.language, title: 'language'.tr,
            onTap: () {
              _manageLanguageFunctionality();
            },
          ),

        ]),
      ),
    );
  }

  void _manageLanguageFunctionality() {
    Get.find<LocalizationController>().saveCacheLanguage(null);
    Get.find<LocalizationController>().searchSelectedLanguage();

    showModalBottomSheet(
      isScrollControlled: true, useRootNavigator: true, context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: const LanguageBottomSheetWidget(),
        );
      },
    ).then((value) => Get.find<LocalizationController>().setLanguage(Get.find<LocalizationController>().getCacheLocaleFromSharedPref()));
  }
}

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool? isButtonActive;
  final Function onTap;
  const SettingsButton({super.key, required this.icon, required this.title, required this.onTap, this.isButtonActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: CustomCard(
        isBorder: false,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: isButtonActive != null ? 8 : Dimensions.paddingSizeDefault,
        ),
        child: Row(children: [

          Icon(icon, size: 25, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Text(title, style: robotoRegular)),

          isButtonActive != null ? CupertinoSwitch(
            value: isButtonActive!,
            onChanged: (bool isActive) => onTap(),
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Theme.of(context).disabledColor.withValues(alpha: 0.5),
          ) : const SizedBox(),

        ]),
      ),
    );
  }
}