import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/domain/centralize_login_enum.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/social_log_in_body_model.dart';
import 'package:stackfood_multivendor/features/auth/screens/new_user_setup_screen.dart';
import 'package:stackfood_multivendor/features/auth/widgets/sign_in/existing_user_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class LoginSuggestionBottomSheet extends StatelessWidget {
  final bool fromCartPage;
  const LoginSuggestionBottomSheet({super.key, this.fromCartPage = false});

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    bool googleLoginActive = Get.find<SplashController>().configModel!.socialLogin![0].status! && Get.find<SplashController>().configModel!.centralizeLoginSetup!.socialLoginStatus!
        && Get.find<SplashController>().configModel!.centralizeLoginSetup!.googleLoginStatus!;

    bool facebookLoginActive = Get.find<SplashController>().configModel!.socialLogin![1].status! && Get.find<SplashController>().configModel!.centralizeLoginSetup!.socialLoginStatus!
        && Get.find<SplashController>().configModel!.centralizeLoginSetup!.facebookLoginStatus!;

    bool canAppleLogin = Get.find<SplashController>().configModel!.appleLogin!.isNotEmpty && Get.find<SplashController>().configModel!.appleLogin![0].status!
        && !GetPlatform.isAndroid;
    bool appleLoginActive = canAppleLogin && Get.find<SplashController>().configModel!.centralizeLoginSetup!.socialLoginStatus!
        && Get.find<SplashController>().configModel!.centralizeLoginSetup!.appleLoginStatus!;

    bool isOtpActive = Get.find<SplashController>().configModel!.centralizeLoginSetup!.otpLoginStatus!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusLarge),
          topRight: Radius.circular(Dimensions.radiusLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Stack(children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5, width: 50,
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomAssetImageWidget(
              Images.loginSuggestionBg,
              height: 120, width: 120,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeOverLarge),
              child: Column(
                children: [
                  Text(
                    fromCartPage ? 'create_account'.tr : "hey_there_welcome".tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    fromCartPage ? 'login_or_signup_to_view_and_track_your_orders'.tr : "login_suggestion_description".tr,
                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeOverLarge),

                  CustomButtonWidget(
                    height: 50,
                    buttonText: 'login'.tr,
                    onPressed: () async {
                      // Get.back(result: true);
                      await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  if(isOtpActive)
                    CustomButtonWidget(
                      height: 50,
                      buttonText: 'otp_login'.tr,
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      textColor: Theme.of(context).textTheme.bodyLarge!.color,
                      onPressed: () async {
                        // Get.back();
                        Get.find<AuthController>().enableOtpView(enable: true);
                        await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                      },
                    ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  if(facebookLoginActive || googleLoginActive || appleLoginActive)
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "or_continue_with".tr,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Get.find<SplashController>().configModel!.socialLogin![0].status! ? InkWell(
                      onTap: () => _googleLogin(googleSignIn),
                      child: Container(
                        height: 40,width: 40,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5, offset: const Offset(2, 2))],
                        ),
                        child: CustomInkWellWidget(
                          radius: Dimensions.radiusDefault,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          onTap: () => _googleLogin(googleSignIn),
                          child: Image.asset(Images.google),
                        ),
                      ),
                    ) : const SizedBox(),

                    Get.find<SplashController>().configModel!.socialLogin![1].status! ? Padding(
                      padding: EdgeInsets.only(left: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeLarge : 0, right: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeLarge),
                      child: InkWell(
                        onTap: () => _facebookLogin(),
                        child: Container(
                          height: 40, width: 40,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5, offset: const Offset(2, 2))],
                          ),
                          child: Image.asset(Images.facebookIcon),
                        ),
                      ),
                    ) : const SizedBox(),

                    canAppleLogin ? Padding(
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                      child: InkWell(
                        onTap: ()=> _appleLogin(),
                        child: Container(
                          height: 40, width: 40,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5, offset: const Offset(2, 2))],
                          ),
                          child: Image.asset(Images.appleLogo),
                        ),
                      ),
                    ) : const SizedBox(),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ],
              ),
            ),
          ]),

          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, color: Theme.of(context).disabledColor),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ]),
      ]),
    );
  }

  void _googleLogin(GoogleSignIn googleSignIn) async {
    if(kIsWeb) {
      await _googleWebSignIn();

    }else{
      try{
        if(googleSignIn.supportsAuthenticate()) {
          await googleSignIn.initialize(serverClientId: AppConstants.googleServerClientId).then((_) async {

            googleSignIn.signOut();
            GoogleSignInAccount googleAccount = await googleSignIn.authenticate();
            const List<String> scopes = <String>['email'];
            GoogleSignInClientAuthorization? auth = await googleAccount.authorizationClient.authorizationForScopes(scopes);

            SocialLogInBodyModel googleBodyModel = SocialLogInBodyModel(
              email: googleAccount.email, token: auth?.accessToken, uniqueId: googleAccount.id,
              medium: 'google', accessToken: 1, loginType: CentralizeLoginType.social.name,
            );

            Get.find<AuthController>().loginWithSocialMedia(googleBodyModel).then((response) {
              if (response.isSuccess) {
                _processSocialSuccessSetup(response, googleBodyModel, null, null);
              } else {
                showCustomSnackBar(response.message);
              }
            });

          });
        }else {
          debugPrint("Google Sign-In not supported on this device.");
        }
      }catch(e){
        debugPrint('Error in google sign in: $e');
      }
    }
  }

  Future<void> _googleWebSignIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential = await auth.signInWithPopup(googleProvider);

      SocialLogInBodyModel googleBodyModel =  SocialLogInBodyModel(
        uniqueId: userCredential.credential?.accessToken,
        token: userCredential.credential?.accessToken,
        accessToken: 1,
        medium: 'google',
        email: userCredential.user?.email,
        loginType: CentralizeLoginType.social.name,
      );

      Get.find<AuthController>().loginWithSocialMedia(googleBodyModel).then((response) {
        if (response.isSuccess) {
          _processSocialSuccessSetup(response, googleBodyModel, null, null);
        } else {
          showCustomSnackBar(response.message);
        }
      });

    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }

  void _facebookLogin() async {
    LoginResult result = await FacebookAuth.instance.login(permissions: ["public_profile", "email"]);
    if (result.status == LoginStatus.success) {
      Map userData = await FacebookAuth.instance.getUserData();

      SocialLogInBodyModel facebookBodyModel = SocialLogInBodyModel(
        email: userData['email'], token: result.accessToken!.tokenString, uniqueId: userData['id'],
        medium: 'facebook', loginType: CentralizeLoginType.social.name,
      );

      Get.find<AuthController>().loginWithSocialMedia(facebookBodyModel).then((response) {
        if (response.isSuccess) {
          _processSocialSuccessSetup(response, null, null, facebookBodyModel);
        } else {
          showCustomSnackBar(response.message);
        }
      });
    }
  }

  void _appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);

    // webAuthenticationOptions: WebAuthenticationOptions(
    //   clientId: Get.find<SplashController>().configModel.appleLogin[0].clientId,
    //   redirectUri: Uri.parse('https://6ammart-web.6amtech.com/apple'),
    // ),

    SocialLogInBodyModel appleBodyModel = SocialLogInBodyModel(
      email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode,
      medium: 'apple', loginType: CentralizeLoginType.social.name,
    );

    Get.find<AuthController>().loginWithSocialMedia(appleBodyModel).then((response) {
      if (response.isSuccess) {
        _processSocialSuccessSetup(response, null, appleBodyModel, null);
      } else {
        showCustomSnackBar(response.message);
      }
    });
  }

  void _processSocialSuccessSetup(ResponseModel response, SocialLogInBodyModel? googleBodyModel, SocialLogInBodyModel? appleBodyModel, SocialLogInBodyModel? facebookBodyModel) {
    String? email = googleBodyModel != null ? googleBodyModel.email : appleBodyModel != null ? appleBodyModel.email : facebookBodyModel?.email;
    if(response.isSuccess && response.authResponseModel != null && response.authResponseModel!.isExistUser != null) {
      if(appleBodyModel != null) {
        email = response.authResponseModel!.email;
        appleBodyModel.email = email;
      }
      if(ResponsiveHelper.isDesktop(Get.context)) {
        Get.back();
        Get.dialog(Center(
          child: ExistingUserBottomSheet(
            userModel: response.authResponseModel!.isExistUser!, email: email, loginType: CentralizeLoginType.social.name,
            socialLogInBodyModel: googleBodyModel ?? appleBodyModel ?? facebookBodyModel,
          ),
        ));
      } else {
        Get.bottomSheet(ExistingUserBottomSheet(
          userModel: response.authResponseModel!.isExistUser!, loginType: CentralizeLoginType.social.name,
          socialLogInBodyModel: googleBodyModel ?? appleBodyModel ?? facebookBodyModel, email: email,
        ));
      }
    } else if(response.isSuccess && response.authResponseModel != null && !response.authResponseModel!.isPersonalInfo!) {
      if(appleBodyModel != null) {
        email = response.authResponseModel!.email;
      }
      if(ResponsiveHelper.isDesktop(Get.context)){
        Get.back();
        Get.dialog(NewUserSetupScreen(name: '', loginType: CentralizeLoginType.social.name, phone: '', email: email));
      } else {
        Get.toNamed(RouteHelper.getNewUserSetupScreen(name: '', loginType: CentralizeLoginType.social.name, phone: '', email: email));
      }
    } else {
      Get.offAllNamed(RouteHelper.getAccessLocationRoute('sign-in'));
    }
  }
}