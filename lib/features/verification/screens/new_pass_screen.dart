import 'package:stackfood_multivendor/common/widgets/validate_check.dart';
import 'package:stackfood_multivendor/features/auth/screens/sign_in_screen.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/profile/domain/models/userinfo_model.dart';
import 'package:stackfood_multivendor/features/verification/controllers/verification_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPassScreen extends StatefulWidget {
  final String? resetToken;
  final String? number;
  final String? email;
  final bool fromPasswordChange;
  final bool fromDialog;
  const NewPassScreen({super.key, required this.resetToken, required this.number, required this.fromPasswordChange, this.fromDialog = false, this.email});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  GlobalKey<FormState>? _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return isDesktop ? Form(
      key: _formKey,
      child: Center(child: Container(
        height: 575, width: 475,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Column(children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.clear),
            ),
          ),

          Expanded(
            child: Padding(
              padding:  EdgeInsets.all(Dimensions.paddingSizeOverLarge),
              child: Column(children: [
                Image.asset(Images.changePasswordBg, height: 170, width: 190),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('enter_your_new_password'.tr, style: robotoBold, textAlign: TextAlign.center),
                const SizedBox(height: Dimensions.paddingSizeOverLarge),

                CustomTextFieldWidget(
                  hintText: '8+characters'.tr,
                  controller: _newPasswordController,
                  focusNode: _newPasswordFocus,
                  nextFocus: _confirmPasswordFocus,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  divider: false,
                  labelText: 'new_password'.tr,
                  validator: (value) => ValidateCheck.validateEmptyText(value, 'please_enter_new_password'.tr),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                CustomTextFieldWidget(
                  hintText: 're_enter_your_password'.tr,
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  onSubmit: (text) => GetPlatform.isWeb ? _onPressedPasswordChange() : null,
                  labelText: 'confirm_password'.tr,
                  validator: (value) => ValidateCheck.validateEmptyText(value, 'please_enter_confirm_password'.tr),
                ),

              ]),
            ),
          ),

          GetBuilder<ProfileController>(builder: (profileController) {
            return GetBuilder<VerificationController>(builder: (verificationController) {
              return CustomButtonWidget(
                radius: Dimensions.radiusDefault,
                margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge),
                buttonText: 'submit'.tr,
                isLoading: widget.fromPasswordChange ? profileController.isLoading : verificationController.isLoading,
                onPressed: () => _onPressedPasswordChange(),
              );
            });
          }),
        ]),
      )),
    ) : Scaffold(
      appBar: CustomAppBarWidget(title: widget.fromPasswordChange ? 'change_password'.tr : 'reset_password'.tr),
      body: Form(
        key: _formKey,
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(
                  children: [

                    Image.asset(Images.changePasswordBg, height: 170, width: 190),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text('enter_your_new_password'.tr, style: robotoBold, textAlign: TextAlign.center),
                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                    CustomTextFieldWidget(
                      hintText: '8+characters'.tr,
                      controller: _newPasswordController,
                      focusNode: _newPasswordFocus,
                      nextFocus: _confirmPasswordFocus,
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      divider: false,
                      labelText: 'new_password'.tr,
                      validator: (value) => ValidateCheck.validateEmptyText(value, 'please_enter_new_password'.tr),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomTextFieldWidget(
                      hintText: 're_enter_your_password'.tr,
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      onSubmit: (text) => GetPlatform.isWeb ? _onPressedPasswordChange() : null,
                      labelText: 'confirm_password'.tr,
                      validator: (value) => ValidateCheck.validateEmptyText(value, 'please_enter_confirm_password'.tr),
                    ),
                  ],
                ),
              ),
            ),

            GetBuilder<ProfileController>(builder: (profileController) {
              return GetBuilder<VerificationController>(builder: (verificationController) {
                return CustomButtonWidget(
                  margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  radius: Dimensions.radiusDefault,
                  buttonText: 'update_password'.tr,
                  isLoading: widget.fromPasswordChange ? profileController.isLoading : verificationController.isLoading,
                  onPressed: () => _onPressedPasswordChange(),
                );
              });
            }),

          ],
        ),
      ),
    );
  }

  void _onPressedPasswordChange() {
    String password = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (_formKey!.currentState!.validate()) {
      if (password.isEmpty) {
        showCustomSnackBar('enter_password'.tr);
      }else if (password.length < 8) {
        showCustomSnackBar('password_should_be'.tr);
      }else if(password != confirmPassword) {
        showCustomSnackBar('confirm_password_does_not_matched'.tr);
      }else {
        if(widget.fromPasswordChange) {
          _changeUserPassword(password);
        }else {
          _resetUserPassword(password, confirmPassword);
        }
      }
    }

  }

  void _changeUserPassword(String password) {
    UserInfoModel user = Get.find<ProfileController>().userInfoModel!;
    user.password = password;
    Get.find<ProfileController>().changePassword(user).then((response) {
      if(response.isSuccess) {
        Get.back();
        showCustomSnackBar('password_updated_successfully'.tr, isError: false);
      }else {
        showCustomSnackBar(response.message);
      }
    });
  }

  void _resetUserPassword(String password, String confirmPassword) {

    String? number = '';
    if(widget.number != null && widget.number != 'null' && widget.number!.isNotEmpty) {
      number = widget.number!.startsWith('+') ? widget.number : '+${widget.number!.substring(1, widget.number!.length)}';
    }

    Get.find<VerificationController>().resetPassword(resetToken: widget.resetToken, phone: number, email: widget.email, password: password, confirmPassword: confirmPassword).then((value) {
      if (value.isSuccess) {
        if(!ResponsiveHelper.isDesktop(Get.context)) {
          Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.resetPassword));
        }else{
          Get.offAllNamed(RouteHelper.getInitialRoute(fromSplash: false))?.then((value) {
            Get.dialog(const SignInScreen(exitFromApp: true, backFromThis: false));
          });
        }
        showCustomSnackBar('password_reset_successfully'.tr, isError: false);
      } else {
        showCustomSnackBar(value.message);
      }
    });
  }
}