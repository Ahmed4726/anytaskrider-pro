import 'package:country_code_picker/country_code_picker.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/screens/pick_map_screen.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryInfoFields extends StatefulWidget {
  final CheckoutController checkoutController;
  final TextEditingController guestNameController;
  final TextEditingController guestNumberController;
  final TextEditingController guestEmailController;
  final TextEditingController guestAddressController;
  final TextEditingController guestStreetNumberController;
  final TextEditingController guestHouseController;
  final TextEditingController guestFloorController;
  final FocusNode guestNameNode;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;
  final FocusNode guestAddressNode;
  final FocusNode guestStreetNumberNode;
  final FocusNode guestHouseNode;
  final FocusNode guestFloorNode;

  const DeliveryInfoFields({super.key, required this.checkoutController,
    required this.guestNameController, required this.guestNumberController, required this.guestEmailController,
    required this.guestAddressController, required this.guestStreetNumberController, required this.guestHouseController, required this.guestFloorController,
    required this.guestNameNode, required this.guestNumberNode, required this.guestEmailNode, required this.guestAddressNode, required this.guestStreetNumberNode,
    required this.guestHouseNode, required this.guestFloorNode});

  @override
  State<DeliveryInfoFields> createState() => _DeliveryInfoFieldsState();
}

class _DeliveryInfoFieldsState extends State<DeliveryInfoFields> {

  @override
  void initState() {
    super.initState();
    AddressModel address = AddressHelper.getAddressFromSharedPref()!;
    Get.find<LocationController>().updateAddress(address);
  }

  @override
  Widget build(BuildContext context) {
    bool takeAway = (widget.checkoutController.orderType == 'take_away');
    bool isDineIn = (widget.checkoutController.orderType == 'dine_in');
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return GetBuilder<LocationController>(builder: (locationController) {
      widget.guestAddressController.text = locationController.address ?? '';

      return Container(
        margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault),
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(takeAway || isDineIn ? 'contact_information'.tr : 'deliver_to'.tr, style: robotoMedium),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: takeAway || isDineIn ? Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2)) : null,
            ),
            child: takeAway || isDineIn ? Column(children: [

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(children: [
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(
                    showTitle: false,
                    hintText: 'enter_your_name'.tr,
                    inputType: TextInputType.name,
                    controller: widget.guestNameController,
                    focusNode: widget.guestNameNode,
                    nextFocus: widget.guestNumberNode,
                    capitalization: TextCapitalization.words,
                    labelText: 'contact_person_name'.tr,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    labelText: 'contact_person_number'.tr,
                    hintText: 'xxx-xxx-xxxxx'.tr,
                    controller: widget.guestNumberController,
                    focusNode: widget.guestNumberNode,
                    nextFocus: widget.guestEmailNode,
                    inputType: TextInputType.phone,
                    isPhone: true,
                    onCountryChanged: (CountryCode countryCode) {
                      widget.checkoutController.countryDialCode = countryCode.dialCode;
                    },
                    countryDialCode: CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code ?? Get.find<LocalizationController>().locale.countryCode,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    labelText: 'email'.tr,
                    hintText: 'enter_email'.tr,
                    controller: widget.guestEmailController,
                    focusNode: widget.guestEmailNode,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.emailAddress,
                  ),

                ]),
              ),
            ]) : Column(crossAxisAlignment: CrossAxisAlignment.start,  children: [

              CustomTextFieldWidget(
                showTitle: false,
                required: true,
                hintText: 'enter_your_name'.tr,
                inputType: TextInputType.name,
                controller: widget.guestNameController,
                focusNode: widget.guestNameNode,
                nextFocus: widget.guestNumberNode,
                capitalization: TextCapitalization.words,
                labelText: 'contact_person_name'.tr,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              CustomTextFieldWidget(
                labelText: 'contact_person_number'.tr,
                hintText: 'xxx-xxx-xxxxx'.tr,
                required: true,
                controller: widget.guestNumberController,
                focusNode: widget.guestNumberNode,
                nextFocus: widget.guestEmailNode,
                inputType: TextInputType.phone,
                isPhone: true,
                onCountryChanged: (CountryCode countryCode) {
                  widget.checkoutController.countryDialCode = countryCode.dialCode;
                },
                countryDialCode: CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code ?? Get.find<LocalizationController>().locale.countryCode,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              CustomTextFieldWidget(
                labelText: 'email'.tr,
                hintText: 'enter_email'.tr,
                controller: widget.guestEmailController,
                focusNode: widget.guestEmailNode,
                nextFocus: widget.guestAddressNode,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      RouteHelper.getPickMapRoute('add-address', false),
                      arguments: PickMapScreen(
                        fromAddAddress: true, fromSignUp: false, fromSplash: false,
                        googleMapController: locationController.mapController,
                        route: null, canRoute: false, fromGuestCheckout: true,
                      ),
                    );
                  },
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.location_on, size: 18, color: Theme.of(context).primaryColor),
                    SizedBox(width: 3),

                    Text('select_from_map'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                  ]),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomTextFieldWidget(
                hintText: 'delivery_address'.tr,
                labelText: 'address'.tr,
                required: true,
                inputType: TextInputType.streetAddress,
                controller: widget.guestAddressController,
                focusNode: widget.guestAddressNode,
                nextFocus: widget.guestStreetNumberNode,
                onChanged: (text) => locationController.setPlaceMark(text),
              ),

              Center(
                child: Visibility(
                  visible: !widget.checkoutController.showMoreDetails,
                  child: Padding(
                    padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                    child: InkWell(
                      onTap: () {
                        widget.checkoutController.setShowMoreDetails(true);
                      },
                      child: Text('${'add_more_details'.tr} +', style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: widget.checkoutController.showMoreDetails,
                child: Column(children: [
                  SizedBox(height: Dimensions.paddingSizeLarge),

                  !ResponsiveHelper.isDesktop(context) ? CustomTextFieldWidget(
                    hintText: 'write_street_number'.tr,
                    labelText: 'street_number'.tr,
                    inputType: TextInputType.streetAddress,
                    controller: widget.guestStreetNumberController,
                    focusNode: widget.guestStreetNumberNode,
                    nextFocus: widget.guestHouseNode,
                  ) : const SizedBox(),
                  SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),

                  Row(
                    children: [
                      ResponsiveHelper.isDesktop(context) ? Expanded(
                        child: CustomTextFieldWidget(
                          hintText: 'write_street_number'.tr,
                          labelText: 'street_number'.tr,
                          inputType: TextInputType.streetAddress,
                          controller: widget.guestStreetNumberController,
                          focusNode: widget.guestStreetNumberNode,
                          nextFocus: widget.guestHouseNode,
                          showTitle: false,
                        ),
                      ) : const SizedBox(),
                      SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

                      Expanded(
                        child: CustomTextFieldWidget(
                          hintText: 'write_house_number'.tr,
                          labelText: 'house'.tr,
                          inputType: TextInputType.text,
                          controller: widget.guestHouseController,
                          focusNode: widget.guestHouseNode,
                          nextFocus: widget.guestFloorNode,
                          showTitle: false,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        child: CustomTextFieldWidget(
                          hintText: 'write_floor_number'.tr,
                          labelText: 'floor'.tr,
                          inputType: TextInputType.text,
                          controller: widget.guestFloorController,
                          focusNode: widget.guestFloorNode,
                          inputAction: TextInputAction.done,
                          showTitle: false,
                        ),
                      ),
                    ],
                  ),
                ]),
              ),

              /*Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(children: [
                  checkoutController.guestAddress == null ? Flexible(
                    child: Row(
                      children: [
                        Text(
                          "no_contact_information_added".tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error)
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Icon(Icons.error, color: Theme.of(context).colorScheme.error, size: 15),

                        const Spacer(),
                      ],
                    ),
                  ) : Flexible(
                    child: Row(children: [

                      Flexible(
                        flex: 4,
                        child: Row(children: [
                          Icon(Icons.person, color: Theme.of(context).disabledColor, size: 20),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Flexible(
                            child: Text(
                              checkoutController.guestAddress!.contactPersonName!,
                              style: robotoBold,
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Flexible(
                        flex: 6,
                        child: Row(children: [
                          Icon(Icons.phone, color: Theme.of(context).disabledColor, size: 20),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Flexible(
                            child: Text(
                              checkoutController.guestAddress!.contactPersonNumber!,
                              style: robotoBold,
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                    ]),
                  ),

                  takeAway ? const SizedBox() : InkWell(
                    onTap: () async {
                      var address = await Get.toNamed(RouteHelper.getEditAddressRoute(checkoutController.guestAddress, fromGuest: true));
                      if(address != null) {
                        checkoutController.setGuestAddress(address);
                        checkoutController.getDistanceInKM(
                          LatLng(double.parse(address.latitude), double.parse(address.longitude)),
                          LatLng(double.parse(checkoutController.restaurant!.latitude!), double.parse(checkoutController.restaurant!.longitude!)),
                        );
                      }
                    },
                    child: Image.asset(Images.editDelivery, height: 20, width: 20, color: Theme.of(context).primaryColor),
                  ),
                ]),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    checkoutController.guestAddress == null ? address.address! : checkoutController.guestAddress!.address!,
                    style: robotoRegular,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  checkoutController.guestAddress == null ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeSmall),

                  (checkoutController.guestAddress != null && checkoutController.guestAddress!.email != null) ? Row(children: [
                    Text('${'email'.tr} - ', style: robotoRegular.copyWith(color: Theme.of(Get.context!).disabledColor)),
                    Flexible(child: Text(checkoutController.guestAddress!.email ?? '', style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ]) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  checkoutController.guestAddress == null ? const SizedBox() : Row(children: [
                    checkoutController.guestAddress!.house != null ? Flexible(
                      child: Row(children: [
                        Text('${'house'.tr} - ', style: robotoRegular.copyWith(color: Theme.of(Get.context!).disabledColor)),
                        Flexible(child: Text(checkoutController.guestAddress!.house ?? '', style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ]),
                    ) : const SizedBox(),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    checkoutController.guestAddress!.floor != null ? Flexible(
                      child: Row(children: [
                        Text('${'floor'.tr} - ', style: robotoRegular.copyWith(color: Theme.of(Get.context!).disabledColor)),
                        Flexible(child: Text(checkoutController.guestAddress!.floor ?? '', style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ]),
                    ) : const SizedBox(),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  ]),
                ]),
              ),*/
            ]),
          ),

        ]),
      );
    });
  }
}
