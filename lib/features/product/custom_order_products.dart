import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/features/product/custom_order_products_controller.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:image_picker/image_picker.dart';

class CustomOrderProducts extends StatefulWidget {
   const CustomOrderProducts({super.key});

  @override
  State<CustomOrderProducts> createState() => _CustomOrderProductsState();
}

class _CustomOrderProductsState extends State<CustomOrderProducts> {
  final TextEditingController _descController = TextEditingController();
  bool _submitting = false;
  // Guest contact fields
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestNumberController = TextEditingController();
  final TextEditingController _guestEmailController = TextEditingController();


  @override
  void initState() {
    super.initState();
    print('[CustomOrderProducts] initState');
    bool hasCtrl = Get.isRegistered<CustomOrderProductsController>();
    print('[CustomOrderProducts] controller registered? $hasCtrl');
    if (!hasCtrl) {
      try {
        Get.put(CustomOrderProductsController(repository: Get.find()));
        hasCtrl = true;
        Get.find<CustomOrderProductsController>().fetchCustomOrders();
        print('[CustomOrderProducts] controller created via Get.put');
      } catch (e) {
        print('[CustomOrderProducts] controller creation failed: $e');
      }
    }
    if (hasCtrl) {
      try {
        final ctrl = Get.find<CustomOrderProductsController>();
        print('[CustomOrderProducts] controller find success. isLoading=${ctrl.isLoading} pickedImage=${ctrl.pickedImage != null}');
      } catch (e) {
        print('[CustomOrderProducts] controller find failed after create: $e');
      }
    }

    // Prefill guest contact number if available
    try {
      final auth = Get.find<AuthController>();
      if (auth.isGuestLoggedIn()) {
        final saved = auth.getGuestNumber();
        if (saved.isNotEmpty) {
          _guestNumberController.text = saved;
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _descController.dispose();
    _guestNameController.dispose();
    _guestNumberController.dispose();
    _guestEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('[CustomOrderProducts] build called');
    final bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    final bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();
    final bool guestCheckoutPermission = isGuestLoggedIn && (Get.find<SplashController>().configModel?.guestCheckoutStatus ?? false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('custom_order'.tr)),
      body: (guestCheckoutPermission || isLoggedIn) ? Builder(builder: (context) {
        final ctrl = Get.isRegistered<CustomOrderProductsController>() ? Get.find<CustomOrderProductsController>() : null;
        print('[CustomOrderProducts] simple body build; ctrlRegistered=${ctrl != null}');
        return ListView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          children: [
            Text('custom_order'.tr, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            if (isGuestLoggedIn) ...[
              // Guest contact info similar to checkout
              CustomTextFieldWidget(
                labelText: 'contact_person_name'.tr,
                hintText: 'contact_person_name'.tr,
                controller: _guestNameController,
                inputType: TextInputType.name,
                inputAction: TextInputAction.next,
                required: true,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                labelText: 'contact_person_number'.tr,
                hintText: 'contact_person_number'.tr,
                controller: _guestNumberController,
                inputType: TextInputType.phone,
                inputAction: TextInputAction.next,
                required: true,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                labelText: 'email'.tr,
                hintText: 'enter_email'.tr,
                controller: _guestEmailController,
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
            ],

            // Description field
            CustomTextFieldWidget(
              labelText: 'description'.tr,
              hintText: 'describe_your_request_optional'.tr,
              controller: _descController,
              maxLines: 8,
              inputType: TextInputType.multiline,
              inputAction: TextInputAction.newline,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              'describe_your_product_or_upload_image'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            // Image chooser area (updates via setState after picking/clearing)
            GestureDetector(
              onTap: () async {
                print('[CustomOrderProducts] pickImage tapped');
                if (ctrl == null) return;
                await showModalBottomSheet(
                  context: context,
                  backgroundColor: Theme.of(context).cardColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
                  ),
                  builder: (_) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_camera_outlined),
                            title: Text('take_photo'.tr),
                            onTap: () async {
                              Navigator.of(context).pop();
                              await ctrl.pickImage(source: ImageSource.camera);
                              if (mounted) setState(() {});
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library_outlined),
                            title: Text('choose_from_gallery'.tr),
                            onTap: () async {
                              Navigator.of(context).pop();
                              await ctrl.pickImage(source: ImageSource.gallery);
                              if (mounted) setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: (ctrl?.pickedImage) != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: kIsWeb
                              ? Image.network(ctrl!.pickedImage!.path, fit: BoxFit.cover)
                              : Image.file(File(ctrl!.pickedImage!.path), fit: BoxFit.cover),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Images.uploadIcon, height: 40, width: 40),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text('upload_image'.tr, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),
            if ((ctrl?.pickedImage) != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    print('[CustomOrderProducts] clearImage tapped');
                    ctrl?.clearImage();
                    if (mounted) setState(() {});
                  },
                  icon: const Icon(Icons.close),
                  label: Text('remove'.tr),
                ),
              ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            // Submit button inline (no GetBuilder to avoid setState during build)
            CustomButtonWidget(
              buttonText: 'send_request'.tr,
              isLoading: _submitting,
              onPressed: () async {
                final ctrl = Get.find<CustomOrderProductsController>();
                if (_submitting) return;
                setState(() { _submitting = true; });
                print('[CustomOrderProducts] submit pressed; descLen=${_descController.text.length} pickedImage=${ctrl.pickedImage != null}');
                // Guest validations similar to checkout
                if (isGuestLoggedIn) {
                  if (_guestNameController.text.trim().isEmpty) {
                    setState(() { _submitting = false; });
                    showCustomSnackBar('please_enter_contact_person_name'.tr);
                    return;
                  }
                  if (_guestNumberController.text.trim().isEmpty) {
                    setState(() { _submitting = false; });
                    showCustomSnackBar('please_enter_contact_person_number'.tr);
                    return;
                  }
                }

                final res = await ctrl.submit(
                  description: _descController.text,
                  contactName: isGuestLoggedIn ? _guestNameController.text.trim() : null,
                  contactNumber: isGuestLoggedIn ? _guestNumberController.text.trim() : null,
                  contactEmail: isGuestLoggedIn ? _guestEmailController.text.trim() : null,
                );
                print('[CustomOrderProducts] submit result: ${res.isSuccess}');
                if (!mounted) return;
                setState(() { _submitting = false; });
                if (res.isSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Get.offNamed(RouteHelper.getCustomOrderListRoute());
                    }
                  });
                }
              },
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),
          ],
        );
      }) : NotLoggedInScreen(callBack: (value) {
        setState(() {});
      }),
      // bottomNavigationBar removed for simplicity; button is inline above
    );
  }

  // All logic handled via CustomOrderProductsController
}
