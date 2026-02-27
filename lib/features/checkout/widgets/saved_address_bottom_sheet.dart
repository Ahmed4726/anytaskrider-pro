import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_loader_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/widgets/permission_dialog.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class SavedAddressBottomSheet extends StatefulWidget {
  const SavedAddressBottomSheet({super.key});

  @override
  State<SavedAddressBottomSheet> createState() => _SavedAddressBottomSheetState();
}

class _SavedAddressBottomSheetState extends State<SavedAddressBottomSheet> {

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return GetBuilder<AddressController>(builder: (addressController) {
      return GetBuilder<CheckoutController>(builder: (checkoutController) {
        return GetBuilder<LocationController>(builder: (locationController) {
          return Container(
            width: isDesktop ? 500 : context.width,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(isDesktop ? 20 : 0)),
            ),
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Center(
                    child: Container(
                      height: 5, width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('select_your_address'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                      InkWell(
                        onTap: () async {
                          Get.back();

                          var address = await Get.toNamed(RouteHelper.getAddAddressRoute(true, checkoutController.restaurant!.zoneId));
                          if(address != null) {

                            checkoutController.insertAddresses(address, notify: true);

                            checkoutController.getDistanceInKM(
                              LatLng(double.parse(address.latitude), double.parse(address.longitude )),
                              LatLng(double.parse(checkoutController.restaurant!.latitude!), double.parse(checkoutController.restaurant!.longitude!)),
                            );
                          }
                        },
                        child: Text('${'add_new_address'.tr} +', style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text('saved_addresses'.tr, style: robotoRegular),

                  addressController.addressList != null ? addressController.addressList!.isNotEmpty ? Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      shrinkWrap: true,
                      itemCount: addressController.addressList?.length,
                      itemBuilder: (context, index) {
                        final address = addressController.addressList?[index];
                        bool isSelectedAddress = checkoutController.address?.latitude == address!.latitude && checkoutController.address?.longitude == address.longitude;

                        return Container(
                          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: isSelectedAddress ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            border: Border.all(
                              color: isSelectedAddress ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).disabledColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: InkWell(
                            onTap: () async {
                              Get.back();

                              checkoutController.insertAddresses(address, notify: true);

                              checkoutController.getDistanceInKM(
                                LatLng(
                                  double.parse(address.latitude!),
                                  double.parse(address.longitude!),
                                ),
                                LatLng(double.parse(checkoutController.restaurant!.latitude!), double.parse(checkoutController.restaurant!.longitude!)),
                              );
                            },
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                Image.asset(
                                  address.addressType == 'home' ? Images.homeIcon : address.addressType == 'office' ? Images.workIcon : Images.otherIcon,
                                  color: isSelectedAddress ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                  height: ResponsiveHelper.isDesktop(context) ? 25 : 18, width: ResponsiveHelper.isDesktop(context) ? 25 : 18,
                                ),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Text(
                                  address.addressType!.tr,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                ),

                                (address.isDefault ?? false) ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
                                  child: Text('default'.tr, style: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeExtraSmall)),
                                ) : const SizedBox(),
                              ]),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text(
                                  address.address ?? '',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ]),
                          ),
                        );
                      },
                    ),
                  ) : Center(child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 100),
                      child: CustomAssetImageWidget(Images.emptyAddress, height: 100, width: 100),
                  )) : Center(child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: CircularProgressIndicator(),
                  )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Center(
                    child: CustomInkWellWidget(
                      onTap: () {
                        _checkPermission(() async {
                          Get.dialog(const CustomLoaderWidget(), barrierDismissible: false);
                          AddressModel addressModel = await locationController.getCurrentLocation(true, mapController: null, showSnackBar: true);

                          if(addressModel.zoneIds!.isNotEmpty) {
                            checkoutController.insertAddresses(addressModel, notify: true);

                            checkoutController.getDistanceInKM(
                              LatLng(
                                locationController.position.latitude, locationController.position.longitude,
                              ),
                              LatLng(double.parse(checkoutController.restaurant!.latitude!), double.parse(checkoutController.restaurant!.longitude!)),
                            );

                            Get.back();
                            Get.back();
                          }
                        });
                      },
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      radius: Dimensions.radiusDefault,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

                        Icon(Icons.my_location_sharp, size: 20, color: Theme.of(context).primaryColor),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Text(
                          'use_my_current_location'.tr,
                          style: robotoRegular,
                        ),

                      ]),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                ]),
              ),

              Positioned(
                top: 0, right: 0,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(Icons.clear, color: Theme.of(context).disabledColor, size: 20),
                ),
              ),
            ]),
          );
        });
      });
    });
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }

}
