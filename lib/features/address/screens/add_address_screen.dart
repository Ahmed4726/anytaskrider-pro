import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/location/screens/pick_map_screen.dart';
import 'package:stackfood_multivendor/features/location/widgets/animated_map_icon_extended.dart';
import 'package:stackfood_multivendor/features/location/widgets/animated_map_icon_minimized.dart';
import 'package:stackfood_multivendor/features/location/widgets/custom_floating_action_button.dart';
import 'package:stackfood_multivendor/features/location/widgets/location_search_dialog.dart';
import 'package:stackfood_multivendor/features/location/widgets/permission_dialog.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/custom_validator.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class AddAddressScreen extends StatefulWidget {
  final bool fromCheckout;
  final int? zoneId;
  final AddressModel? address;
  final bool forGuest;

  const AddAddressScreen({super.key, required this.fromCheckout, this.zoneId, this.address, this.forGuest = false});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  final FocusNode _levelNode = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;
  double _currentZoomLevel = 16.0;

  bool _otherSelect = false;
  String? _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty
      ? Get.find<AuthController>().getUserCountryCode()
      : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall() {
    Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
    if (Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
    if (widget.address == null) {
      _initialPosition = LatLng(
        double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lng ?? '0'),
      );
    } else {
      Get.find<LocationController>().updateAddress(widget.address!);
      _initialPosition = LatLng(
        double.parse(widget.address?.latitude ?? '0'),
        double.parse(widget.address?.longitude ?? '0'),
      );

      if (widget.address?.addressType == 'home') {
        Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
      } else if (widget.address?.addressType == 'office') {
        Get.find<LocationController>().setAddressTypeIndex(1, notify: false);
      } else {
        Get.find<LocationController>().setAddressTypeIndex(2, notify: false);
        _levelController.text = widget.address?.addressType ?? '';
        _otherSelect = true;
      }

      _splitPhoneNumber(widget.address!.contactPersonNumber!);
      _contactPersonNameController.text = widget.address!.contactPersonName ?? '';
      _emailController.text = widget.address!.email ?? '';
      _streetNumberController.text = widget.address!.road ?? '';
      _houseController.text = widget.address!.house ?? '';
      _floorController.text = widget.address!.floor ?? '';
    }
  }

  void _splitPhoneNumber(String number) async {
    PhoneValid phoneNumber = await CustomValidator.isPhoneValid(number);
    _countryDialCode = '+${phoneNumber.countryCode}';
    _contactPersonNumberController.text = phoneNumber.phone.replaceFirst('+${phoneNumber.countryCode}', '');
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBarWidget(
        title: widget.forGuest ? 'delivery_address'.tr : widget.address == null ? 'add_new_address'.tr : 'update_address'.tr,
      ),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: GetBuilder<ProfileController>(builder: (profileController) {
          if (profileController.userInfoModel != null && _contactPersonNameController.text.isEmpty) {
            _contactPersonNameController.text = '${profileController.userInfoModel!.fName} ${profileController.userInfoModel!.lName}';
            _splitPhoneNumber(profileController.userInfoModel!.phone!);
          }

          return GetBuilder<LocationController>(builder: (locationController) {
            _addressController.text = locationController.address ?? '';

            return Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController, 
                  physics: const BouncingScrollPhysics(), 
                  padding: EdgeInsets.all(isDesktop ? 0 : Dimensions.paddingSizeDefault),
                  child: Column(children: [
                    WebScreenTitleWidget(title: widget.address == null ? 'add_new_address'.tr : 'update_address'.tr),
                    SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 0),
                    
                    FooterViewWidget(
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: isDesktop ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Expanded(flex: 6, child: addressSectionWidget(locationController, isDesktop)),
                            const SizedBox(width: Dimensions.paddingSizeLarge),

                            Expanded(flex: 4, child: informationSectionWidget(locationController, isDesktop)),

                          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            addressSectionWidget(locationController, isDesktop),
                            
                            //informationSectionWidget(locationController, isDesktop),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),

              !isDesktop ? GetBuilder<AddressController>(builder: (addressController) {
                return Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: CustomButtonWidget(
                    radius: Dimensions.paddingSizeSmall,
                    width: Dimensions.webMaxWidth,
                    buttonText: widget.forGuest ? 'continue'.tr : widget.address == null ? 'save_location'.tr : 'update_address'.tr,
                    isLoading: addressController.isLoading,
                    onPressed: locationController.loading ? null : () => _onSaveButtonPressed(locationController),
                  ),
                );
              }) : const SizedBox(),

            ]);
          });
        }),
      ),
    );
  }

  Widget addressSectionWidget(LocationController locationController, bool isDesktop) {
    return Container(
      decoration: isDesktop ? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ) : const BoxDecoration(),
      padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeLarge : 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

        CustomCard(
          isBorder: false,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.fromCheckout ? 'set_your_exact_delivery_location'.tr : 'add_the_location_correctly'.tr,
              style: robotoSemiBold,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Container(
              height: 320,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(width: 1.5, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Stack(clipBehavior: Clip.none, children: [

                  GoogleMap(
                    initialCameraPosition: CameraPosition(target: _initialPosition, zoom: _currentZoomLevel),
                    minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                    onTap: isDesktop ? null : (latLng) {
                      Get.toNamed(
                        RouteHelper.getPickMapRoute('add-address', false),
                        arguments: PickMapScreen(
                          fromAddAddress: true,
                          fromSignUp: false,
                          fromSplash: false,
                          googleMapController: locationController.mapController,
                          route: null,
                          canRoute: false,
                        ),
                      );
                      },
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    indoorViewEnabled: false,
                    mapToolbarEnabled: false,
                    onCameraMove: ((position) => _cameraPosition = position),
                    onCameraMoveStarted: () {
                      locationController.updateCameraMovingStatus(true);
                    },
                    onCameraIdle: () {
                      locationController.updateCameraMovingStatus(false);
                      locationController.updatePosition(_cameraPosition, true);
                    },
                    onMapCreated: (GoogleMapController controller) {
                      locationController.setMapController(controller);
                      if (widget.address == null) {
                        locationController.getCurrentLocation(true, mapController: controller);
                      }
                    },
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                      Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                      Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                      Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                      Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
                    },
                    style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                  ),

                  Center(child: Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.pickMapIconSize * 0.65),
                    child: locationController.isCameraMoving ? const AnimatedMapIconExtended() : const AnimatedMapIconMinimised(),
                  )),

                  Positioned(
                    top: 10, left: 10, right: 10,
                    child: LocationSearchDialog(
                      mapController: locationController.mapController,
                      fromAddress: true,
                      pickedLocation: _addressController.text,
                      callBack: (Position? position) {
                        if (position != null) {
                          _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
                          locationController.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
                          locationController.updatePosition(_cameraPosition, true);
                        }
                      },
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          color: Theme.of(context).cardColor,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)],
                        ),
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text('search_here'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 10, right: 10,
                    child: Column(children: [

                      CustomFloatingActionButton(
                        onTap: () {
                          Get.toNamed(
                            RouteHelper.getPickMapRoute('add-address', false),
                            arguments: PickMapScreen(
                              fromAddAddress: true, fromSignUp: false, fromSplash: false,
                              googleMapController: locationController.mapController,
                              route: null, canRoute: false,
                            ),
                          );
                        },
                        icon: Icons.fullscreen,
                        heroTag: 'view_full_map_button',
                        iconColor: Theme.of(context).disabledColor, iconSize: 20,
                      ),
                      SizedBox(height: Dimensions.paddingSizeSmall),

                      CustomFloatingActionButton(
                        onTap: () {
                          _checkPermission(() {
                            locationController.getCurrentLocation(true, mapController: locationController.mapController);
                          });
                        },
                        icon: Icons.my_location,
                        heroTag: 'my_location',
                        iconColor: Theme.of(context).disabledColor, iconSize: 20,
                      ),
                      SizedBox(height: Dimensions.paddingSizeSmall),

                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(children: [
                          CustomFloatingActionButton(
                            icon: Icons.add, heroTag: 'add_button',
                            iconColor: Theme.of(context).disabledColor, iconSize: 20,
                            onTap: () {
                              _currentZoomLevel++;
                              locationController.mapController?.animateCamera(CameraUpdate.zoomTo(_currentZoomLevel));
                            },
                          ),

                          Container(
                            width: 20, height: 1,
                            color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                          ),

                          CustomFloatingActionButton(
                            icon: Icons.remove, heroTag: 'remove_button',
                            iconColor: Theme.of(context).disabledColor, iconSize: 20,
                            onTap: () {
                              _currentZoomLevel--;
                              locationController.mapController?.animateCamera(CameraUpdate.zoomTo(_currentZoomLevel));
                            },
                          ),

                        ]),
                      ),

                    ]),
                  ),

                ]),
              ),
            ),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        CustomCard(
          isBorder: false,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('address_type'.tr, style: robotoSemiBold),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            SizedBox(
              height: 45,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: locationController.addressTypeList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                  child: InkWell(
                    onTap: () {
                      _otherSelect = index == 2;
                      locationController.setAddressTypeIndex(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: locationController.addressTypeIndex == index ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                        border: Border.all(color: locationController.addressTypeIndex == index ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
                      ),
                      child: Row(children: [
                        SizedBox(
                          height: 20, width: 20,
                          child: Image.asset(
                            index == 0 ? Images.homeIcon : index == 1 ? Images.workIcon : Images.otherIcon,
                            color: locationController.addressTypeIndex == index ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
                          ),
                        ),
                        SizedBox(width: Dimensions.paddingSizeSmall),

                        Text(
                          index == 0 ? 'home'.tr : index == 1 ? 'office'.tr : 'others'.tr,
                          style: robotoRegular.copyWith(color: locationController.addressTypeIndex == index ? Theme.of(context).cardColor : Theme.of(context).disabledColor),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: _otherSelect ? Dimensions.paddingSizeLarge : 0),

            _otherSelect ? CustomTextFieldWidget(
              hintText: 'ex_02'.tr,
              labelText: 'level_name'.tr,
              inputType: TextInputType.text,
              controller: _levelController,
              focusNode: _levelNode,
              nextFocus: _addressNode,
              capitalization: TextCapitalization.words,
              showBorder: true,
            ) : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeOverLarge),

            CustomTextFieldWidget(
              hintText: 'delivery_address'.tr,
              labelText: 'delivery_address'.tr,
              required: true,
              inputType: TextInputType.streetAddress,
              focusNode: _addressNode,
              nextFocus: _nameNode,
              controller: _addressController,
              onChanged: (text) => locationController.setPlaceMark(text),
              showBorder: true,
            ),
            SizedBox(height: isDesktop ? 0 : Dimensions.paddingSizeOverLarge),

            isDesktop ? SizedBox() : informationSectionWidget(locationController, isDesktop),
          ]),
        ),
        
      ]),
    );
  }

  Widget informationSectionWidget(LocationController locationController, bool isDesktop) {
    return Container(
      decoration: isDesktop ? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ) : const BoxDecoration(),
      padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeOverLarge : 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        CustomTextFieldWidget(
          hintText: 'ex_doe'.tr,
          labelText: 'name'.tr,
          required: true,
          inputType: TextInputType.name,
          controller: _contactPersonNameController,
          focusNode: _nameNode,
          nextFocus: _numberNode,
          capitalization: TextCapitalization.words,
          showBorder: true,
        ),
        const SizedBox(height: Dimensions.paddingSizeOverLarge),
        
        CustomTextFieldWidget(
          hintText: 'xxx-xxx-xxxxx',
          labelText: 'phone'.tr,
          required: true,
          controller: _contactPersonNumberController,
          focusNode: _numberNode,
          nextFocus: widget.forGuest ? _emailFocus : _streetNode,
          inputType: TextInputType.phone,
          isPhone: true,
          onCountryChanged: (CountryCode countryCode) {
            _countryDialCode = countryCode.dialCode;
          },
          countryDialCode: _countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
        ),
        const SizedBox(height: Dimensions.paddingSizeOverLarge),
        
        widget.forGuest ? CustomTextFieldWidget(
          hintText: 'enter_email'.tr,
          labelText: 'email'.tr,
          controller: _emailController,
          focusNode: _emailFocus,
          nextFocus: _streetNode,
          inputType: TextInputType.emailAddress,
        ) : const SizedBox(),
        SizedBox(height: widget.forGuest ? Dimensions.paddingSizeOverLarge : 0),
        
        CustomTextFieldWidget(
          hintText: "ex_02".tr,
          labelText: 'street_number'.tr,
          inputType: TextInputType.streetAddress,
          focusNode: _streetNode,
          nextFocus: _houseNode,
          controller: _streetNumberController,
        ),
        const SizedBox(height: Dimensions.paddingSizeOverLarge),
        
        Row(children: [
          Expanded(
            child: CustomTextFieldWidget(
              hintText: 'ex_1005/2'.tr,
              labelText: 'house'.tr,
              inputType: TextInputType.text,
              focusNode: _houseNode,
              nextFocus: _floorNode,
              controller: _houseController,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeLarge),
          
          Expanded(
            child: CustomTextFieldWidget(
              hintText: 'ex_02'.tr,
              labelText: 'floor'.tr,
              inputType: TextInputType.text,
              focusNode: _floorNode,
              inputAction: TextInputAction.done,
              controller: _floorController,
            ),
          ),
        ]),
        SizedBox(height: isDesktop ? Dimensions.paddingSizeOverLarge : 0),
        
        isDesktop ? GetBuilder<AddressController>(builder: (addressController) {
          return CustomButtonWidget(
            radius: Dimensions.paddingSizeSmall,
            width: Dimensions.webMaxWidth,
            margin: EdgeInsets.all(isDesktop ? 0 : Dimensions.paddingSizeSmall),
            buttonText: widget.forGuest ? 'continue'.tr : widget.address == null ? 'save_location'.tr : 'update_address'.tr,
            isLoading: addressController.isLoading,
            onPressed: locationController.loading ? null : () => _onSaveButtonPressed(locationController),
          );
        }) : const SizedBox(),
        
      ]),
    );
  }

  void _onSaveButtonPressed(LocationController locationController) async {
    String numberWithCountryCode = _countryDialCode! + _contactPersonNumberController.text;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    AddressModel? addressModel = _prepareAddressModel(locationController, phoneValid.isValid, numberWithCountryCode);
    if (addressModel == null) {
      return;
    }

    if (widget.forGuest) {
      addressModel.email = _emailController.text;
      Get.back(result: addressModel);
    } else {
      if (widget.address == null) {
        _addAddress(addressModel);
      } else {
        _updateAddress(addressModel);
      }
    }
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    } else {
      onTap();
    }
  }

  AddressModel? _prepareAddressModel(LocationController locationController, bool isValid, String numberWithCountryCode) {
    if (_contactPersonNameController.text.isEmpty) {
      showCustomSnackBar('please_provide_contact_person_name'.tr);
    } else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      AddressModel addressModel = AddressModel(
        id: widget.address?.id,
        addressType: _otherSelect ? _levelController.text : locationController.addressTypeList[locationController.addressTypeIndex],
        contactPersonName: _contactPersonNameController.text,
        contactPersonNumber: numberWithCountryCode,
        address: _addressController.text,
        latitude: locationController.position.latitude.toString(),
        longitude: locationController.position.longitude.toString(),
        zoneId: locationController.zoneID,
        road: _streetNumberController.text.trim(),
        house: _houseController.text.trim(),
        floor: _floorController.text.trim(),
      );

      return addressModel;
    }
    return null;
  }

  void _addAddress(AddressModel addressModel) {
    Get.find<AddressController>().addAddress(addressModel, widget.fromCheckout, widget.zoneId).then((response) {
      if (response.isSuccess) {
        Get.back(result: addressModel);
        //Get.offAllNamed(RouteHelper.getAddressRoute());
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    });
  }

  void _updateAddress(AddressModel addressModel) {
    Get.find<AddressController>().updateAddress(addressModel, widget.address!.id).then((response) {
      if (response.isSuccess) {
        Get.back();
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    });
  }
}
