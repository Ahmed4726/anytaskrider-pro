import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/address/widgets/address_confirmation_dialogue_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressCardWidget extends StatelessWidget {
  final AddressModel? address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function? onTap;
  final bool isSelected;
  final bool fromDashBoard;
  final int? index;
  const AddressCardWidget({super.key, required this.address, required this.fromAddress, this.onTap, this.fromCheckout = false,
    this.isSelected = false, this.fromDashBoard = false, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: fromCheckout ? 0 : Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeSmall),
          decoration: fromDashBoard ? BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent, width: isSelected ? 1 : 0),
          ) : fromCheckout ? const BoxDecoration() : BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor, width: isSelected ? 0.5 : 0),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Row(mainAxisSize: MainAxisSize.min, children: [

                  Image.asset(
                    address?.addressType == 'home' ? Images.houseIcon : address?.addressType == 'office' ? Images.officeIcon : Images.otherIcon,
                    height: ResponsiveHelper.isDesktop(context) ? 25 : 20, width: ResponsiveHelper.isDesktop(context) ? 25 : 20,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Flexible(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(address?.addressType?.tr ?? '', style: robotoMedium),

                        (address?.isDefault ?? false) ? Container(
                          margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Text('default'.tr, style: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeExtraSmall)),
                        ) : const SizedBox(),
                      ]),
                    
                      Text(
                        address?.address ?? '',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                  ),

                ]),
              ]),
            ),

            fromAddress ? PopupMenuButton(
              itemBuilder: (context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'is_default',
                    child: Row(children: [
                      Expanded(child: Text('mark_as_default'.tr, style: robotoRegular)),
                      SizedBox(width: 20),

                      Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.green, size: 20),
                    ]),
                  ),

                  PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      Expanded(child: Text('edit'.tr, style: robotoRegular)),
                      SizedBox(width: 20),

                      Icon(CupertinoIcons.pencil_circle_fill, color: Colors.blue, size: 20),
                    ]),
                  ),

                  PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Expanded(child: Text('delete'.tr, style: robotoRegular)),
                      SizedBox(width: 20),

                      Icon(CupertinoIcons.delete, color: Colors.red, size: 20),
                    ]),
                  ),
                ];
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              child: Icon(Icons.more_vert, size: 20, color: Theme.of(context).primaryColor),
              onSelected: (dynamic value) {
                if (value == 'delete') {
                  if(Get.isSnackbarOpen) {
                    Get.back();
                  }
                  Get.dialog(AddressConfirmDialogueWidget(
                    icon: Images.locationConfirm,
                    title: 'are_you_sure'.tr,
                    description: 'you_want_to_delete_this_location'.tr,
                    onYesPressed: () {
                      Get.find<AddressController>().deleteAddress(address?.id, index!).then((response) {
                        Get.back();
                        showCustomSnackBar(response.message, isError: !response.isSuccess);
                      });
                    },
                  ));
                }else if (value == 'edit'){
                  Get.toNamed(RouteHelper.getEditAddressRoute(address));
                }else if (value == 'is_default'){
                  if(Get.isSnackbarOpen) {
                    Get.back();
                  }
                  Get.dialog(AddressConfirmDialogueWidget(
                    isDefault: true,
                    icon: Images.locationConfirm,
                    title: 'are_you_sure'.tr,
                    description: 'you_want_to_default_this_location'.tr,
                    onYesPressed: () {
                      Get.find<AddressController>().markDefault(address!.id!).then((response) {
                        Get.back();
                        showCustomSnackBar(response.message, isError: !response.isSuccess);
                      });
                    },
                  ));
                }
              },
            ) : const SizedBox(),

          ]),
        ),
      ),
    );
  }
}