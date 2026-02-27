import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:stackfood_multivendor/common/widgets/validate_check.dart';
import 'package:stackfood_multivendor/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliverymanAdditionalDataSectionWidget extends StatelessWidget {
  final DeliverymanRegistrationController deliverymanController;
  final ScrollController scrollController;
  const DeliverymanAdditionalDataSectionWidget({super.key, required this.deliverymanController, required this.scrollController});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return deliverymanController.dataList!.isNotEmpty ? Container(
      decoration: isDesktop ? null : BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 0)],
      ),
      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      padding: EdgeInsets.only(
        left: isDesktop ? 0 : Dimensions.paddingSizeSmall,
        right: isDesktop ? 0 : Dimensions.paddingSizeSmall,
        top: isDesktop ? 0 : Dimensions.paddingSizeSmall,
        bottom: isDesktop ? 0 : Dimensions.paddingSizeSmall,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        isDesktop ? SizedBox() : Text('additional_info'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        SizedBox(height: isDesktop ? 0 : Dimensions.paddingSizeExtraSmall),

        isDesktop ? SizedBox() : Text('additional_info_subtitle'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
        SizedBox(height: isDesktop ? 0 :  Dimensions.paddingSizeDefault),

        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: deliverymanController.dataList!.length,
          itemBuilder: (context, index) {
            bool showTextField = deliverymanController.dataList![index].fieldType == 'text' || deliverymanController.dataList![index].fieldType == 'number' || deliverymanController.dataList![index].fieldType == 'email' || deliverymanController.dataList![index].fieldType == 'phone';
            bool showDate = deliverymanController.dataList![index].fieldType == 'date';
            bool showCheckBox = deliverymanController.dataList![index].fieldType == 'check_box';
            bool showFile = deliverymanController.dataList![index].fieldType == 'file';
            return Padding(
              padding: EdgeInsets.only(bottom: index == deliverymanController.dataList!.length - 1 ? 0 : Dimensions.paddingSizeOverLarge),
              child: showTextField ? CustomTextFieldWidget(
                hintText: deliverymanController.dataList![index].placeholderData ?? '',
                controller: deliverymanController.additionalList![index],
                inputType: deliverymanController.dataList![index].fieldType == 'number' ? TextInputType.number
                  : deliverymanController.dataList![index].fieldType == 'phone' ? TextInputType.phone
                  : deliverymanController.dataList![index].fieldType == 'email' ? TextInputType.emailAddress
                  : TextInputType.text,
                isRequired: deliverymanController.dataList![index].isRequired == 1,
                capitalization: TextCapitalization.words,
                labelText: deliverymanController.dataList![index].placeholderData ?? '',
                required: deliverymanController.dataList![index].isRequired == 1,
                validator: deliverymanController.dataList![index].isRequired == 1 ? (value) => ValidateCheck.validateEmptyText(value, null) : null,
              ) : showDate ? Column(children: [

                // Row(children: [
                //   Text(deliverymanController.camelCaseToSentence(deliverymanController.dataList![index].inputData ?? ''), style: robotoMedium),
                //
                //   Text(
                //     deliverymanController.dataList![index].isRequired == 1 ? ' *' : '',
                //     style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),
                //   ),
                // ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
                  ),
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
                  child: InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                        deliverymanController.setAdditionalDate(index, formattedDate);
                      }
                    },
                    child: Row(children: [
                      Expanded(child: Text(deliverymanController.additionalList![index] ?? '${deliverymanController.camelCaseToSentence(deliverymanController.dataList![index].inputData!)}${deliverymanController.dataList![index].isRequired == 1 ? ' *' : ''}', style: robotoRegular.copyWith(color: Theme.of(context).hintColor))),

                      Icon(Icons.calendar_month_rounded, color: Theme.of(context).disabledColor),
                    ]),
                  ),
                ),

              ]) : showCheckBox ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Row(children: [
                  Text(deliverymanController.camelCaseToSentence(deliverymanController.dataList![index].inputData ?? ''), style: robotoMedium),

                  Text(
                    deliverymanController.dataList![index].isRequired == 1 ? ' *' : '',
                    style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ]),

                ListView.builder(
                  itemCount: deliverymanController.dataList![index].checkData!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, i) {
                    return Row(children: [
                      Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        value: deliverymanController.additionalList![index][i] == deliverymanController.dataList![index].checkData![i],
                        onChanged: (bool? isChecked) {
                          deliverymanController.setAdditionalCheckData(index, i, deliverymanController.dataList![index].checkData![i]);
                        }
                      ),
                      Text(
                        deliverymanController.dataList![index].checkData![i],
                        style: robotoRegular,
                      ),
                    ]);
                  },
                )

              ]) : showFile ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(children: [
                    Text(deliverymanController.camelCaseToSentence(deliverymanController.dataList![index].inputData ?? ''), style: robotoMedium),

                    Text(
                      deliverymanController.dataList![index].isRequired == 1 ? ' *' : '',
                      style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Builder(builder: (context) {
                    FilePickerResult? file = 0 == deliverymanController.additionalList![index].length ? null : deliverymanController.additionalList![index][0];
                    bool isImage = false;
                    String fileName = '';
                    if(file != null) {
                      if(!GetPlatform.isWeb) {
                        fileName = file.files.single.path!.split('/').last;
                        isImage = file.files.single.path!.contains('jpg') || file.files.single.path!.contains('jpeg') || file.files.single.path!.contains('png');
                      } else {
                        fileName = file.files.first.name;
                        isImage = file.files.first.name.contains('jpg') || file.files.first.name.contains('jpeg') || file.files.first.name.contains('png');
                      }
                    }
                    return deliverymanController.dataList![index].mediaData!.uploadMultipleFiles == 1 ? SizedBox(
                      height: 120,
                      child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: deliverymanController.additionalList![index].length + 1,
                      itemBuilder: (context, i) {
                        FilePickerResult? file = i == deliverymanController.additionalList![index].length ? null : deliverymanController.additionalList![index][i];
                        bool isImage = false;
                        String fileName = '';
                        if (file != null) {
                          if (!GetPlatform.isWeb) {
                            fileName = file.files.single.path!.split('/').last;
                            isImage = file.files.single.path!.contains('jpg') || file.files.single.path!.contains('jpeg') ||
                                file.files.single.path!.contains('png');
                          } else {
                            fileName = file.files.first.name;
                            isImage = file.files.first.name.contains('jpg') || file.files.first.name.contains('jpeg') ||
                                file.files.first.name.contains('png');
                          }
                        }

                        return file == null ? Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          child: InkWell(
                            onTap: () async {
                              await deliverymanController.pickFile(index, deliverymanController.dataList![index].mediaData!);
                            },
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                color: Theme.of(context).disabledColor,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const [5, 5],
                                padding: const EdgeInsets.all(0),
                                radius: const Radius.circular(Dimensions.radiusDefault),
                              ),
                              child: Container(
                                height: 120,
                                width: 160,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                ),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(Icons.cloud_upload_outlined, size: 30, color: Theme.of(context).disabledColor),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  Text(
                                    'select_a_file'.tr,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ) : Stack(children: [
                          Container(
                            width: 160, height: 120,
                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                            ),
                            child: isImage && !GetPlatform.isWeb ? ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: GetPlatform.isWeb ? Image.network(
                                file.files.single.path!, width: 100, height: 100, fit: BoxFit.cover,
                              ) : Image.file(
                                File(file.files.single.path!), width: 100, height: 100, fit: BoxFit.cover,
                              ),
                            ) : Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              alignment: Alignment.center,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Image.asset(Images.documentIcon, height: 30, width: 30, fit: BoxFit.contain),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                Text(
                                  fileName,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                  maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                ),
                              ]),
                            ),
                          ),

                          Positioned(
                            top: 0, right: 10,
                            child: InkWell(
                              onTap: (){
                                deliverymanController.removeAdditionalFile(index, i);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.1)),
                                ),
                                padding: const EdgeInsets.all(2),
                                child: Icon(CupertinoIcons.clear, color: Theme.of(context).colorScheme.error, size: 15),
                              ),
                            ),
                          ),
                        ]);
                      }),
                    ) : deliverymanController.dataList![index].mediaData!.uploadMultipleFiles == 0 && file != null ? Stack(children: [

                      Container(
                        height: 70,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: isImage && !GetPlatform.isWeb ? ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: GetPlatform.isWeb ? Image.network(
                              file.files.single.path!, width: 100, height: 100, fit: BoxFit.cover,
                            ) : Image.file(
                              File(file.files.single.path!), width: 500, height: 70, fit: BoxFit.cover,
                            ),
                          ) : DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              color: Theme.of(context).disabledColor,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [5, 5],
                              padding: const EdgeInsets.all(0),
                              radius: const Radius.circular(Dimensions.radiusDefault),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                              ),
                              child: Row(children: [
                                Image.asset(Images.documentIcon, height: 30, width: 30, fit: BoxFit.contain),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Text(fileName, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  SizedBox(height: isDesktop ? 3 : Dimensions.paddingSizeExtraSmall),

                                  Text(
                                    '${file.files.single.size / 1000} Kbps',
                                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall),
                                  ),

                                ])),

                              ]),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 0, right: 0, bottom: 10,
                        child: IconButton(
                          onPressed: (){
                            deliverymanController.removeAdditionalFile(index, 0);
                          },
                          icon: Icon(CupertinoIcons.clear, color: Theme.of(context).disabledColor, size: 20),
                        ),
                      ),

                    ]) : InkWell(
                      onTap: () async {
                        await deliverymanController.pickFile(index, deliverymanController.dataList![index].mediaData!);
                      },
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: Theme.of(context).disabledColor,
                          strokeWidth: 1,
                          strokeCap: StrokeCap.butt,
                          dashPattern: const [5, 5],
                          padding: const EdgeInsets.all(0),
                          radius: const Radius.circular(Dimensions.radiusDefault),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                            ),
                            child: Row(children: [
                              Icon(Icons.cloud_upload_outlined, size: 35, color: Theme.of(context).disabledColor),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                Text(
                                  deliverymanController.dataList![index].mediaData!.uploadMultipleFiles == 1 ? 'select_multiple_files'.tr : 'select_a_file'.tr,
                                  style: robotoRegular,
                                ),

                                Text(
                                  'jpg_png_or_pdf_file_size_no_more_than_ten_mb'.tr,
                                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall),
                                ),

                              ])),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                ),
                                alignment: Alignment.center,
                                child: Text('select'.tr, style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                              ),

                            ]),
                          ),
                        ),
                      ),
                    );
                  }),

                ]),
              ) : SizedBox(),
            );

          },
        ),
      ]),
    ) : const SizedBox();
  }
}
