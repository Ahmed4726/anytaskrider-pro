import 'package:intl/intl.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/menu/widgets/portion_widget.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/sign_in_screen.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isRightSide = Get.find<SplashController>().configModel!.currencySymbolDirection == 'right';

    return Scaffold(
      body: GetBuilder<ProfileController>(builder: (profileController) {
        return GetBuilder<SplashController>(builder: (splashController) {

          bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
          final configModel = splashController.configModel;
          
          return Column(children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeOverLarge,
                  top: 50, bottom: isLoggedIn ? Dimensions.paddingSizeOverLarge : Dimensions.paddingSizeLarge,
                ),
                child: Column(children: [
                  Row(children: [

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(1),
                      child: ClipOval(child: CustomImageWidget(
                        placeholder: isLoggedIn ? Images.profilePlaceholder : Images.guestIcon,
                        image: '${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.imageFullUrl : ''}',
                        height: 70, width: 70, fit: BoxFit.cover, imageColor: isLoggedIn ? Theme.of(context).hintColor : null,
                      )),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        isLoggedIn && profileController.userInfoModel == null ? Shimmer(
                          duration: const Duration(seconds: 2),
                          enabled: true,
                          child: Container(
                            height: 16, width: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 200],
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                        ) : Text(
                          isLoggedIn ? '${profileController.userInfoModel?.fName} ${profileController.userInfoModel?.lName}' : 'guest_user'.tr,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        isLoggedIn && profileController.userInfoModel != null ? Text(
                          DateConverter.containTAndZToUTCFormat(profileController.userInfoModel!.createdAt!),
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ) : SizedBox() ,

                      ]),
                    ),
                  ]),

                  isLoggedIn ? SizedBox() : Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault),
                    child: Divider(height: 0, color: Color(0xff334257).withValues(alpha: 0.1), thickness: 1),
                  ),

                  isLoggedIn ? SizedBox() : Row(children: [

                    Expanded(child: Text('for_more_personalised_and_smooth_experience'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor.withValues(alpha: 0.9)))),
                    SizedBox(width: Dimensions.paddingSizeDefault),

                    SizedBox(
                      width: 130,
                      child: CustomButtonWidget(
                        buttonText: '${'login'.tr}/ ${'signup'.tr}',
                        height: 40, color: Colors.white.withValues(alpha: 0.9),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () async {
                          if(!isDesktop) {
                            Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute))?.then((value) {
                              if(AuthHelper.isLoggedIn()) {
                                profileController.getUserInfo();
                              }
                            });
                          }else{
                            Get.dialog(const SignInScreen(exitFromApp: true, backFromThis: true)).then((value) {
                              if(AuthHelper.isLoggedIn()) {
                                profileController.getUserInfo();
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ]),
                ]),
              ),
            ),
          
            Expanded(child: SingleChildScrollView(
              child: Ink(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  isLoggedIn ? Row(children: [
          
                    Expanded(
                      child: CustomCard(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraLarge),
                        borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        child: Column(children: [
          
                          Text(
                            NumberFormat.compact().format(profileController.userInfoModel?.orderCount ?? 0),
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          
                          Text('total_order'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
          
                        ]),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
          
                    Expanded(
                      child: CustomCard(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraLarge),
                        borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        child: Column(children: [
          
                          Text(
                            NumberFormat.compact().format(profileController.userInfoModel?.loyaltyPoint ?? 0),
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          
                          Text('loyalty_point'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
          
                        ]),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
          
                    Expanded(
                      child: CustomCard(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraLarge),
                        borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        child: Column(children: [
                          Text(
                            '${isRightSide ? '' : '${Get.find<SplashController>().configModel!.currencySymbol!} '}'
                            '${NumberFormat.compact().format(profileController.userInfoModel?.walletBalance ?? 0)}''${isRightSide ? ' ${Get.find<SplashController>().configModel!.currencySymbol!}' : ''}',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          
                          Text('wallet'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                        ]),
                      ),
                    ),
          
                  ]) : SizedBox(),
                  SizedBox(height: isLoggedIn ? Dimensions.paddingSizeSmall : 0),
          
                  Text(
                    'general'.tr,
                    style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
          
                  CustomCard(
                    borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      isLoggedIn ? PortionWidget(icon: Images.editProfileIcon, title: 'edit_profile'.tr, hideDivider: isLoggedIn ? false : true, route: RouteHelper.getUpdateProfileRoute()) : SizedBox(),

                      PortionWidget(icon: Images.addressIcon, title: 'my_address'.tr, route: RouteHelper.getAddressRoute()),

                      PortionWidget(icon: Images.settingsIcon, title: 'settings'.tr, hideDivider: true, route: RouteHelper.getSettingsRoute()),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
          
                  Text(
                    'promotional_activity'.tr,
                    style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
          
                  CustomCard(
                    borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      PortionWidget(icon: Images.couponIcon, title: 'coupon'.tr, route: RouteHelper.getCouponRoute(fromCheckout: false)),
                      PortionWidget(icon: Images.orders, title: 'custom_orders'.tr, route: RouteHelper.getCustomOrderListRoute(),),

                      configModel!.loyaltyPointStatus! ? PortionWidget(
                        icon: Images.pointIcon, title: 'loyalty_points'.tr, route: RouteHelper.getLoyaltyRoute(),
                        hideDivider: configModel.customerWalletStatus! ? false : true,
                        suffix: !isLoggedIn ? null : '${profileController.userInfoModel?.loyaltyPoint != null ? Get.find<ProfileController>().userInfoModel!.loyaltyPoint.toString() : '0'} ${'points'.tr}' ,
                      ) : const SizedBox(),
          
                      configModel.customerWalletStatus! ? PortionWidget(
                        icon: Images.walletIcon, title: 'my_wallet'.tr, hideDivider: true, route: RouteHelper.getWalletRoute(fromMenuPage: true),
                        suffix: !isLoggedIn ? null : PriceConverter.convertPrice(profileController.userInfoModel != null ? Get.find<ProfileController>().userInfoModel!.walletBalance : 0),
                      ) : const SizedBox(),
                    ]),
                  ),
          
                  configModel.refEarningStatus! || (configModel.toggleDmRegistration! && !isDesktop)|| (configModel.toggleRestaurantRegistration! && !isDesktop) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: Dimensions.paddingSizeDefault),
          
                    Text(
                      'earnings'.tr,
                      style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    CustomCard(
                      borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                      child: Column(children: [
          
                        configModel.refEarningStatus! ? PortionWidget(
                          icon: Images.referIcon, title: 'refer_and_earn'.tr, route: RouteHelper.getReferAndEarnRoute(),
                        ) : const SizedBox(),
          
                        (configModel.toggleDmRegistration! && !isDesktop) ? PortionWidget(
                          icon: Images.dmIcon, title: 'join_as_a_delivery_man'.tr, route: RouteHelper.getDeliverymanRegistrationRoute(),
                        ) : const SizedBox(),
          
                        (configModel.toggleRestaurantRegistration! && !isDesktop) ? PortionWidget(
                          icon: Images.storeIcon, title: 'open_store'.tr, hideDivider: true, route: RouteHelper.getRestaurantRegistrationRoute(),
                        ) : const SizedBox(),
                      ]),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ]) : const SizedBox(),

                  Text(
                    'help_and_support'.tr,
                    style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomCard(
                    borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      PortionWidget(icon: Images.chatIcon, title: 'live_chat'.tr, route: RouteHelper.getConversationRoute()),
                      PortionWidget(icon: Images.helpIcon, title: 'help_and_support'.tr, route: RouteHelper.getSupportRoute()),
                      PortionWidget(icon: Images.aboutIcon, title: 'about_us'.tr, route: RouteHelper.getAboutUsRoute()),
                      PortionWidget(icon: Images.termsIcon, title: 'terms_conditions'.tr, route: RouteHelper.getTermsAndConditionRoute()),
                      PortionWidget(icon: Images.privacyIcon, title: 'privacy_policy'.tr, route: RouteHelper.getPrivacyPolicyRoute()),

                      configModel.refundPolicyStatus! ? PortionWidget(
                        icon: Images.refundIcon, title: 'refund_policy'.tr, route: RouteHelper.getRefundPolicyRoute(),
                      ) : const SizedBox(),

                      configModel.cancellationPolicyStatus! ? PortionWidget(
                        icon: Images.cancelationIcon, title: 'cancellation_policy'.tr, route: RouteHelper.getCancellationPolicyRoute(),
                      ) : const SizedBox(),

                      configModel.shippingPolicyStatus! ? PortionWidget(
                        icon: Images.shippingIcon, title: 'shipping_policy'.tr, hideDivider: true, route: RouteHelper.getShippingPolicyRoute(),
                      ) : const SizedBox(),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
          
                  isLoggedIn ? InkWell(
                    onTap: () async {
                      Get.dialog(ConfirmationDialogWidget(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () async {
                        Get.find<ProfileController>().setForceFullyUserEmpty();
                        Get.find<AuthController>().socialLogout();
                        Get.find<AuthController>().resetOtpView();
                        Get.find<CartController>().clearCartList();
                        Get.find<FavouriteController>().removeFavourites();
                        await Get.find<AuthController>().clearSharedData();
                        Get.offAllNamed(RouteHelper.getInitialRoute());
                      }), useSafeArea: false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                          child: Icon(Icons.power_settings_new_sharp, size: 14, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          
                        Text('logout'.tr, style: robotoMedium),
                      ]),
                    ),
                  ) : SizedBox(),
          
                  const SizedBox(height:  Dimensions.paddingSizeLarge),
          
                ]),
              ),
            )),
          ]);
        });
      }),
    );
  }
}
