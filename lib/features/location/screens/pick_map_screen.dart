import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/location/widgets/animated_map_icon_extended.dart';
import 'package:stackfood_multivendor/features/location/widgets/animated_map_icon_minimized.dart';
import 'package:stackfood_multivendor/features/location/widgets/custom_floating_action_button.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/widgets/location_search_dialog.dart';
import 'package:stackfood_multivendor/features/location/widgets/permission_dialog.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class PickMapScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromSplash;
  final bool fromAddAddress;
  final bool canRoute;
  final String? route;
  final GoogleMapController? googleMapController;
  final bool fromGuestCheckout;
  const PickMapScreen({
    super.key, required this.fromSignUp, required this.fromAddAddress, required this.canRoute,
    required this.route, this.googleMapController, required this.fromSplash, this.fromGuestCheckout = false,
  });

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;
  double _currentZoomLevel = 16.0;

  @override
  void initState() {
    super.initState();

    Get.find<LocationController>().makeLoadingOff();

    if(widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }
    _initialPosition = LatLng(
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : (widget.fromAddAddress && widget.fromGuestCheckout) ? CustomAppBarWidget(title: 'delivery_address'.tr) : null,
      body: SafeArea(child: Center(child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: GetBuilder<LocationController>(builder: (locationController) {
          return Stack(children: [

            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.fromAddAddress ? LatLng(locationController.position.latitude, locationController.position.longitude) : _initialPosition,
                zoom: _currentZoomLevel,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
                if(!widget.fromAddAddress && widget.route != 'splash') {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: mapController).then((value) {
                    if(widget.fromSplash) {
                      _onPickAddressButtonPressed(locationController);
                    }
                  });
                }
              },
              zoomControlsEnabled: false,
              onCameraMove: (CameraPosition cameraPosition) {
                _cameraPosition = cameraPosition;
              },
              onCameraMoveStarted: () {
                locationController.updateCameraMovingStatus(true);
                locationController.disableButton();
              },
              onCameraIdle: () {
                locationController.updateCameraMovingStatus(false);
                Get.find<LocationController>().updatePosition(_cameraPosition, false);
              },
              style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
            ),

            Center(child: Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.pickMapIconSize * 0.65),
              child: locationController.isCameraMoving ? const AnimatedMapIconExtended() : const AnimatedMapIconMinimised(),
            )),

            Positioned(
              top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
              child: LocationSearchDialog(mapController: _mapController, pickedLocation: locationController.pickAddress!),
            ),

            Positioned(
              bottom: 100, right: Dimensions.paddingSizeLarge,
              child: Column(children: [

                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, spreadRadius: 0.5, offset: const Offset(0, 4))],
                  ),
                  child: FloatingActionButton(
                    mini: true, backgroundColor: Theme.of(context).cardColor,
                    onPressed: () => _checkPermission(() {
                      Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                    }),
                    child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, spreadRadius: 0.5, offset: const Offset(0, 4))],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(children: [
                    CustomFloatingActionButton(
                      icon: Icons.add, heroTag: 'add_button',
                      onTap: () {
                        _currentZoomLevel++;
                        _mapController?.animateCamera(CameraUpdate.zoomTo(_currentZoomLevel));
                      },
                    ),

                    Container(
                      width: 20, height: 1,
                      color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                    ),

                    CustomFloatingActionButton(
                      icon: Icons.remove, heroTag: 'remove_button',
                      onTap: () {
                        _currentZoomLevel--;
                        _mapController?.animateCamera(CameraUpdate.zoomTo(_currentZoomLevel));
                      },
                    ),


                  ]),
                ),


              ]),
            ),

            /*Positioned(
              bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
              child: CustomButtonWidget(
                buttonText: locationController.inZone ? widget.fromAddAddress ? 'confirm_address'.tr : 'set_location'.tr
                    : 'service_not_available_in_this_area'.tr,
                isLoading: locationController.isLoading,
                onPressed: (locationController.buttonDisabled || locationController.loading) ? null
                    : () => _onPickAddressButtonPressed(locationController),
              ),
            ),*/

            Positioned(
              bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: (locationController.buttonDisabled || locationController.loading) ? null : () => _onPickAddressButtonPressed(locationController),
                child: Container(
                  padding: EdgeInsets.all((locationController.buttonDisabled || locationController.loading) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault - 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (locationController.buttonDisabled || locationController.loading) ? Theme.of(context).primaryColor.withValues(alpha: 0.8) : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: (locationController.buttonDisabled || locationController.loading) ? Center(
                    child: LoadingAnimationWidget.waveDots(color: Colors.white, size: 40),
                  ) : Text(
                    locationController.inZone ? widget.fromAddAddress ? 'confirm_address'.tr : 'set_location'.tr : 'service_not_available_in_this_area'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white),
                  ),
                ),
              ),
            ),

          ]);
        }),
      ))),
    );
  }

  void _onPickAddressButtonPressed(LocationController locationController) {
    if(locationController.pickPosition.latitude != 0 && locationController.pickAddress!.isNotEmpty) {
      if(widget.fromAddAddress) {
        if(widget.googleMapController != null) {
          widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
            locationController.pickPosition.latitude, locationController.pickPosition.longitude,
          ), zoom: 17)));
        }

        locationController.addAddressData();
        Get.back();
      }else {
        AddressModel address = AddressModel(
          latitude: locationController.pickPosition.latitude.toString(),
          longitude: locationController.pickPosition.longitude.toString(),
          addressType: 'others', address: locationController.pickAddress,
        );
        locationController.saveAddressAndNavigate(address, widget.fromSignUp, widget.route, widget.canRoute, ResponsiveHelper.isDesktop(Get.context));
      }
    }else {
      showCustomSnackBar('pick_an_address'.tr);
    }
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
