import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_drop_down_button.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/gap_widget.dart';
import 'package:stackfood_multivendor/common/widgets/validate_check.dart';
import 'package:stackfood_multivendor/common/widgets/web_screen_title_widget.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/shift_model.dart';
import 'package:stackfood_multivendor/features/auth/widgets/trams_conditions_check_box_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:stackfood_multivendor/features/auth/widgets/deliveryman_additional_data_section_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/pass_view_widget.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DeliverymanRegistrationWebScreen extends StatefulWidget {
  final ScrollController scrollController;
  final TextEditingController fNameController;
  final TextEditingController lNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController identityNumberController;
  final FocusNode fNameNode;
  final FocusNode lNameNode;
  final FocusNode emailNode;
  final FocusNode phoneNode;
  final FocusNode passwordNode;
  final FocusNode confirmPasswordNode;
  final FocusNode identityNumberNode;
  final String? countryDialCode;
  final Widget buttonView;
  const DeliverymanRegistrationWebScreen({
    super.key, required this.scrollController, required this.fNameController, required this.lNameController, required this.emailController,
    required this.phoneController, required this.passwordController, required this.confirmPasswordController,
    required this.identityNumberController, required this.fNameNode, required this.lNameNode, required this.emailNode,
    required this.phoneNode, required this.passwordNode, required this.confirmPasswordNode, required this.identityNumberNode,
    this.countryDialCode, required this.buttonView,
  });

  @override
  State<DeliverymanRegistrationWebScreen> createState() => _DeliverymanRegistrationWebScreenState();
}

class _DeliverymanRegistrationWebScreenState extends State<DeliverymanRegistrationWebScreen> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanController) {
      return SingleChildScrollView(
        controller: widget.scrollController,
        child: FooterViewWidget(
          child: Center(
            child: Column(children: [
              WebScreenTitleWidget( title: 'join_as_a_delivery_man'.tr),
              const Gap(Dimensions.paddingSizeLarge),

              Text('delivery_man_registration'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                'complete_registration_process_to_serve_as_delivery_man_in_this_platform'.tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ),
              const Gap(Dimensions.paddingSizeLarge),

              SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('delivery_man_information'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const Gap(Dimensions.paddingSizeSmall),

                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(
                          flex: 2,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Row(children: [
                              Expanded(child: CustomTextFieldWidget(
                                hintText: 'write_first_name'.tr,
                                controller: widget.fNameController,
                                capitalization: TextCapitalization.words,
                                inputType: TextInputType.name,
                                focusNode: widget.fNameNode,
                                nextFocus: widget.lNameNode,
                                prefixIcon: CupertinoIcons.person_alt_circle_fill,
                                labelText: 'first_name'.tr,
                                required: true,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "first_name_field_is_required".tr),
                              )),
                              const Gap.horizontal(Dimensions.paddingSizeLarge),

                              Expanded(child: CustomTextFieldWidget(
                                hintText: 'write_last_name'.tr,
                                controller: widget.lNameController,
                                capitalization: TextCapitalization.words,
                                inputType: TextInputType.name,
                                focusNode: widget.lNameNode,
                                nextFocus: widget.phoneNode,
                                prefixIcon: CupertinoIcons.person_alt_circle_fill,
                                labelText: 'last_name'.tr,
                                required: true,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "last_name_field_is_required".tr),
                              )),
                            ]),
                            const Gap(Dimensions.paddingSizeExtraLarge),

                            Row(children: [
                              Expanded(child:CustomTextFieldWidget(
                                hintText: 'write_email'.tr,
                                controller: widget.emailController,
                                focusNode: widget.emailNode,
                                nextFocus: widget.passwordNode,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: CupertinoIcons.mail_solid,
                                labelText: 'email'.tr,
                                required: true,
                                validator: (value) => ValidateCheck.validateEmail(value),
                              )),
                              const Gap.horizontal(Dimensions.paddingSizeLarge),

                              Expanded(child: Stack(clipBehavior: Clip.none, children: [
                                CustomDropdownButton(
                                  hintText: 'select_delivery_type'.tr,
                                  prefixIcon: Image.asset(Images.dmType, height: 20, width: 20, fit: BoxFit.contain,),
                                  // prefixIcon: CustomAssetImageWidget(Images.dmType, height: 20, width: 20, fit: BoxFit.contain,),
                                  items: deliverymanController.dmTypeList,
                                  selectedValue: deliverymanController.selectedDmType,
                                  onChanged: (value) {
                                    deliverymanController.setSelectedDmType(value);
                                  },
                                ),

                                Positioned(
                                  left: 12, top: -13,
                                  child: Container(
                                    color: Theme.of(context).cardColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: Row(children: [
                                      Text('select_delivery_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                                      Text(' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                                    ]),
                                  ),
                                ),
                              ])),
                            ]),
                            const Gap(Dimensions.paddingSizeExtraLarge),

                            Row(children: [
                              Expanded(child: deliverymanController.zoneList != null ? deliverymanController.zoneList!.isNotEmpty ? Stack(clipBehavior: Clip.none, children: [
                                CustomDropdownButton(
                                  hintText: 'select_delivery_zone'.tr,
                                  prefixIcon: Image.asset(Images.dmZone, height: 20, width: 20, fit: BoxFit.contain,),
                                  dropdownMenuItems: deliverymanController.zoneList!.map((zone) => DropdownMenuItem<String>(
                                    value: zone.id.toString(),
                                    child: Text(zone.name ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault)),
                                  )).toList(),
                                  selectedValue: deliverymanController.selectedDeliveryZoneId,
                                  onChanged: (value) {
                                    deliverymanController.setSelectedDeliveryZone(zoneId: value);
                                  },
                                ),

                                Positioned(
                                  left: 12, top: -13,
                                  child: Container(
                                    color: Theme.of(context).cardColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: Row(children: [
                                      Text('select_delivery_zone'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                                      Text(' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                                    ]),
                                  ),
                                ),
                              ]) : ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                child: Shimmer(
                                  child: Container(height: 50, color: Theme.of(context).shadowColor),
                                ),
                              ) : Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                ),
                                height: 50,
                                child: Center(
                                  child: Text('no_zone_available'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                                ),
                              )),
                              const Gap.horizontal(Dimensions.paddingSizeLarge),

                              Expanded(
                                child: deliverymanController.vehicles != null ? deliverymanController.vehicles!.isNotEmpty ? Stack(clipBehavior: Clip.none, children: [
                                  CustomDropdownButton(
                                    hintText: 'select_vehicle_type'.tr,
                                    prefixIcon: Image.asset(Images.vehicleType, height: 20, width: 20, fit: BoxFit.contain,),
                                    dropdownMenuItems: deliverymanController.vehicles!.map((vehicle) => DropdownMenuItem<String>(
                                      value: vehicle.id.toString(),
                                      child: Text(vehicle.type ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault)),
                                    )).toList(),
                                    selectedValue: deliverymanController.selectedVehicleId,
                                    onChanged: (value) {
                                      deliverymanController.setSelectedVehicleType(vehicleId: value);
                                    },
                                  ),

                                  Positioned(
                                    left: 12, top: -13,
                                    child: Container(
                                      color: Theme.of(context).cardColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Row(children: [
                                        Text('select_vehicle_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                                        Text(' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                                      ]),
                                    ),
                                  ),
                                ]) : ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  child: Shimmer(
                                    child: Container(height: 50, color: Theme.of(context).shadowColor),
                                  ),
                                ) : Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).shadowColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  ),
                                  height: 50,
                                  child: Center(
                                    child: Text('no_vehicle_available'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                                  ),
                                ),
                              ),
                            ]),

                            (deliverymanController.selectedDmType == 'freelancer') ?
                            (deliverymanController.shifts != null && deliverymanController.shifts!.isNotEmpty) ?
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              Stack(clipBehavior: Clip.none, children: [
                                CustomDropdownButton(
                                  hintText: 'working_shift'.tr,
                                  prefixIcon: Image.asset(Images.workingShift, height: 20, width: 20, fit: BoxFit.contain,),
                                  dropdownMenuItems: deliverymanController.shifts!.map((shift) {
                                    bool isSelected = deliverymanController.selectedShifts.any((deliveryManShift) => deliveryManShift.id == shift.id);
                                    bool isFullDay = shift.isFullDay == 1;
                                    bool hasFullDay = deliverymanController.selectedShifts.any((deliveryManShift) => deliveryManShift.isFullDay == 1);
                                    bool hasOtherShifts = deliverymanController.selectedShifts.any((deliveryManShift) => deliveryManShift.isFullDay != 1);
                                    bool shouldDisable = isSelected || (isFullDay && hasOtherShifts) || (!isFullDay && hasFullDay);

                                    return DropdownMenuItem<ShiftModel>(
                                      value: shift,
                                      enabled: !shouldDisable,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected ? Theme.of(context).disabledColor.withValues(alpha: 0.1) : Colors.transparent,
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        ),
                                        child: Text(
                                          '${shift.name} (${DateConverter.timeStringToTime(shift.startTime!)} - ${DateConverter.timeStringToTime(shift.endTime!)})',
                                          style: robotoRegular.copyWith(
                                            color: shouldDisable ? Theme.of(context).disabledColor : Theme.of(context).textTheme.bodyLarge?.color,
                                            fontSize: Dimensions.fontSizeDefault,
                                          ), maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  selectedValue: null,
                                  selectedItemBuilder: (BuildContext context) {
                                    return (deliverymanController.shifts ?? []).map((shift) {
                                      return Text('working_shift'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault));
                                    }).toList();
                                  },
                                  onChanged: (value) {
                                    if (value != null && !deliverymanController.selectedShifts.any((s) => s.id == value.id)) {
                                      deliverymanController.toggleShift(value);
                                    }
                                  },
                                ),

                                Positioned(left: 12, top: -13,
                                  child: Container(
                                    color: Theme.of(context).cardColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: Row(children: [
                                      Text('working_shift'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                                      Text(' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)
                                      ),
                                    ]),
                                  ),
                                ),
                              ]),

                              deliverymanController.selectedShifts.isNotEmpty ? Column(children: [
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.start, children: List.generate(
                                    deliverymanController.selectedShifts.length,
                                    growable: true, (index) {
                                  final shift = deliverymanController.selectedShifts[index];
                                  return Chip(
                                    label: Text(shift.name ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                    deleteIcon: Icon(Icons.close, size: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
                                    onDeleted: () {
                                      deliverymanController.removeShift(shift);
                                    },
                                    backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.01),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge), side: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.01)),),
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 4),
                                  );
                                }),
                                )]
                              ) : SizedBox.shrink(),

                              const SizedBox(height: Dimensions.paddingSizeOverLarge),
                            ]) : SizedBox.shrink() : SizedBox.shrink(),
                          ]),
                        ),
                        Gap.horizontal(Dimensions.paddingSizeLarge),

                        Expanded(
                          flex: 1,
                          child: Container(
                            width: context.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(
                                children: [
                                  Text('delivery_man_image'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  Text(' *', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red)),
                                ],
                              ),
                              const Gap(Dimensions.paddingSizeSmall),

                              Align(
                                alignment: Alignment.center,
                                child: Stack(clipBehavior: Clip.none, children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    child: deliverymanController.pickedImage != null ? GetPlatform.isWeb ? Image.network(
                                      deliverymanController.pickedImage!.path, width: 100, height: 100, fit: BoxFit.cover,
                                    ) : Image.file(
                                      File(deliverymanController.pickedImage!.path), width: 100, height: 100, fit: BoxFit.cover,
                                    ) : Container(
                                      width: 100, height: 100,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      ),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                        CustomAssetImageWidget(Images.pictureIcon, width: 25, height: 25, fit: BoxFit.cover),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                          child: Text(
                                            'click_to_add'.tr,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue), textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0, right: 0, top: 0, left: 0,
                                    child: InkWell(
                                      onTap: () => deliverymanController.pickDmImage(true, false),
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                                          strokeWidth: 1,
                                          strokeCap: StrokeCap.butt,
                                          dashPattern: const [5, 5],
                                          padding: const EdgeInsets.all(0),
                                          radius: const Radius.circular(Dimensions.radiusDefault),
                                        ),
                                        child: const SizedBox(),
                                      ),
                                    ),
                                  ),

                                  deliverymanController.pickedImage != null ? Positioned(
                                    bottom: -10, right: -10,
                                    child: InkWell(
                                      onTap: () => deliverymanController.removeDmImage(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Theme.of(context).cardColor, width: 2),
                                          shape: BoxShape.circle, color: Theme.of(context).colorScheme.error,
                                        ),
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                        child:  Icon(Icons.remove, size: 18, color: Theme.of(context).cardColor,),
                                      ),
                                    ),

                                  ) : const SizedBox(),
                                ]),
                              ),
                              const Gap(Dimensions.paddingSizeSmall),

                              Center(
                                child: Text(
                                  'jpg_png_jpeg_less_than_1_mb_ratio_1_1'.tr, textAlign: TextAlign.center,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                ),
                              ),
                              const Gap(Dimensions.paddingSizeSmall),
                            ]),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                  const Gap(Dimensions.paddingSizeExtraLarge),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('identity_info'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const Gap(Dimensions.paddingSizeLarge),

                      Row(children: [
                        Expanded(
                          child: Stack(clipBehavior: Clip.none, children: [
                            CustomDropdownButton(
                              hintText: 'select_identity_type'.tr,
                              prefixIcon: Image.asset(Images.identityType, height: 20, width: 20, fit: BoxFit.contain,),
                              items: deliverymanController.identityTypeList,
                              selectedValue: deliverymanController.selectedIdentityType,
                              onChanged: (value) {
                                deliverymanController.setSelectedIdentityType(value);
                              },
                            ),

                            Positioned(
                              left: 12, top: -13,
                              child: Container(
                                color: Theme.of(context).cardColor,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Row(children: [
                                  Text('select_identity_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                                  Text(' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                                ]),
                              ),
                            ),
                          ]),
                        ),
                        const Gap.horizontal(Dimensions.paddingSizeLarge),

                        Expanded(
                          child: CustomTextFieldWidget(
                            hintText: 'Ex: XXXXX-XXXXXXX-X',
                            controller: widget.identityNumberController,
                            focusNode: widget.identityNumberNode,
                            inputAction: TextInputAction.done,
                            labelText: 'identity_number'.tr,
                            required: true,
                            prefixIcon: Icons.twenty_mp_rounded,
                            fromDeliveryRegistration: true,
                            isEnabled: deliverymanController.selectedIdentityType != null,
                            validator: (value) => ValidateCheck.validateEmptyText(value, "identity_number_field_is_required".tr),
                          ),
                        ),
                      ]),
                      const Gap(Dimensions.paddingSizeOverLarge),

                      Container(
                        width: context.width, height: 170,
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Column(children: [
                          Row(
                            children: [
                              Text('identity_image'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              Text(' *', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red)),
                              const Gap.horizontal(Dimensions.paddingSizeExtraSmall),

                              Text(
                                'upload_identity_image_ratio'.tr,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                              ),
                            ],
                          ),
                          const Gap(Dimensions.paddingSizeSmall),

                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: deliverymanController.pickedIdentities.length+1,
                              itemBuilder: (context, index) {
                                XFile? file = index == deliverymanController.pickedIdentities.length ? null : deliverymanController.pickedIdentities[index];
                                if(index == deliverymanController.pickedIdentities.length) {
                                  return InkWell(
                                    onTap: () => deliverymanController.pickDmImage(false, false),
                                    child: DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                        color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                                        strokeWidth: 1,
                                        strokeCap: StrokeCap.butt,
                                        dashPattern: const [5, 5],
                                        radius: const Radius.circular(Dimensions.radiusDefault),
                                      ),
                                      child: Container(
                                        height: 120, width: 250, alignment: Alignment.center,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          CustomAssetImageWidget(Images.pictureIcon, width: 25, height: 25, fit: BoxFit.cover),
                                          const SizedBox(height: Dimensions.paddingSizeSmall),

                                          Text(
                                            'click_to_add'.tr,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue), textAlign: TextAlign.center,
                                          ),
                                        ]),
                                      ),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                  child: DottedBorder(
                                    options: RoundedRectDottedBorderOptions(
                                      color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                                      strokeWidth: 1,
                                      strokeCap: StrokeCap.butt,
                                      dashPattern: const [5, 5],
                                      radius: const Radius.circular(Dimensions.radiusDefault),
                                    ),
                                    child: Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        child: GetPlatform.isWeb ? Image.network(
                                          file!.path, width: 250, height: 120, fit: BoxFit.cover,
                                        ) : Image.file(
                                          File(file!.path), width: 250, height: 120, fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: 10, top: 10,
                                        child: InkWell(
                                          onTap: () => deliverymanController.removeIdentityImage(index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              border: Border.all(color: Theme.of(context).primaryColor),
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            ),
                                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                            child: const Icon(Icons.delete_forever_sharp, color: Colors.red, size: 20),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                  const Gap(Dimensions.paddingSizeExtraLarge),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('additional_info'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      DeliverymanAdditionalDataSectionWidget(deliverymanController: deliverymanController, scrollController: widget.scrollController),
                    ]),
                  ),
                  const Gap(Dimensions.paddingSizeExtraLarge),

                  Container(
                    width: Dimensions.webMaxWidth,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('account_info'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const Gap(Dimensions.paddingSizeLarge),

                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(
                          child: CustomTextFieldWidget(
                            hintText: 'phone'.tr,
                            controller: widget.phoneController,
                            focusNode: widget.phoneNode,
                            nextFocus: widget.emailNode,
                            inputType: TextInputType.phone,
                            isPhone: true,
                            onCountryChanged: (CountryCode countryCode) {
                              deliverymanController.setCountryDialCode(countryCode.dialCode);
                            },
                            countryDialCode: deliverymanController.countryDialCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode,
                            labelText: 'phone'.tr,
                            required: true,
                            validator: (value) => ValidateCheck.validatePhone(value, null),
                          ),
                        ),
                        const Gap.horizontal(Dimensions.paddingSizeLarge),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          CustomTextFieldWidget(
                            hintText: '8+characters'.tr,
                            controller: widget.passwordController,
                            focusNode: widget.passwordNode,
                            nextFocus: widget.confirmPasswordNode,
                            inputType: TextInputType.visiblePassword,
                            isPassword: true,
                            prefixIcon: Icons.lock,
                            onChanged: (value){
                              if(value != null && value.isNotEmpty){
                                if(!deliverymanController.showPassView){
                                  deliverymanController.showHidePassView();
                                }
                                deliverymanController.validPassCheck(value);
                              }else{
                                if(deliverymanController.showPassView){
                                  deliverymanController.showHidePassView();
                                }
                              }
                            },
                            labelText: 'password'.tr,
                            required: true,
                            validator: (value) => ValidateCheck.validateEmptyText(value, "enter_password_for_delivery_man".tr),
                          ),

                          deliverymanController.showPassView ? const PassViewWidget() : const SizedBox(),
                        ])),
                        const Gap.horizontal(Dimensions.paddingSizeLarge),

                        Expanded(child: CustomTextFieldWidget(
                          hintText: '8+characters'.tr,
                          controller: widget.confirmPasswordController,
                          focusNode: widget.confirmPasswordNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          labelText: 'confirm_password'.tr,
                          required: true,
                          validator: (value) => ValidateCheck.validateConfirmPassword(value, widget.passwordController.text),
                        ))
                      ]),
                      const Gap(Dimensions.paddingSizeDefault),
                    ]),
                  ),
                  const Gap(Dimensions.paddingSizeExtraLarge),

                  Row(children: [
                    Expanded(child: TramsConditionsCheckBoxWidget(deliverymanRegistrationController: deliverymanController, fromDmRegistration: true)),

                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      CustomButtonWidget(
                        width: 165,
                        textColor: Theme.of(context).hintColor,
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                        onPressed: () {
                          widget.phoneController.text = '';
                          widget.emailController.text = '';
                          widget.fNameController.text = '';
                          widget.lNameController.text = '';
                          widget.lNameController.text = '';
                          widget.passwordController.text = '';
                          widget.confirmPasswordController.text = '';
                          widget.identityNumberController.text = '';
                          deliverymanController.resetDmRegistrationData();
                          deliverymanController.setDeliverymanAdditionalJoinUsPageData(isUpdate: true);
                        },
                        buttonText: 'reset'.tr,
                        isBold: false,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      SizedBox(width: 165, child: widget.buttonView),
                    ]),
                  ]),

                  const Gap(40),
                ]),
              ),
            ]),
          ),
        ),
      );
    });
  }
}
