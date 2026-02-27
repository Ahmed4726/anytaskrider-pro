import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_drop_down_button.dart';
import 'package:stackfood_multivendor/common/widgets/validate_check.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/delivery_man_body_model.dart';
import 'package:stackfood_multivendor/features/auth/widgets/trams_conditions_check_box_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/web/deliveryman_registration_web_screen.dart';
import 'package:stackfood_multivendor/features/auth/widgets/deliveryman_additional_data_section_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/pass_view_widget.dart';
import 'package:stackfood_multivendor/helper/custom_validator.dart';
import 'package:stackfood_multivendor/helper/extensions.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helper/date_converter.dart';
import '../domain/models/shift_model.dart';

class DeliveryManRegistrationScreen extends StatefulWidget {
  const DeliveryManRegistrationScreen({super.key});

  @override
  State<DeliveryManRegistrationScreen> createState() => _DeliveryManRegistrationScreenState();
}

class _DeliveryManRegistrationScreenState extends State<DeliveryManRegistrationScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  GlobalKey<FormState>? infoFormKey = GlobalKey<FormState>();
  final JustTheController tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();
    DeliverymanRegistrationController deliverymanController = Get.find<DeliverymanRegistrationController>();
    deliverymanController.setCountryDialCode(CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode, notify: false);
    deliverymanController.resetDmRegistrationData();
    deliverymanController.getZoneList(forDeliveryRegistration: true);
    deliverymanController.getVehicleList();
    deliverymanController.getShiftList();
    deliverymanController.setDeliverymanAdditionalJoinUsPageData(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if(isDesktop){
          Future.delayed(const Duration(milliseconds: 0), () => Get.back());
        }else{
          if(Get.find<DeliverymanRegistrationController>().selectedTabIndex == 2) {
            Get.find<DeliverymanRegistrationController>().setSelectedTabIndex(1);
          }else if(Get.find<DeliverymanRegistrationController>().selectedTabIndex == 1) {
            Get.find<DeliverymanRegistrationController>().setSelectedTabIndex(0);
          } else {
            Future.delayed(const Duration(milliseconds: 0), () => Get.back());
          }
        }
      },
      child: GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanController) {
        bool generalInfoTab = deliverymanController.selectedTabIndex == 0;
        bool verificationInfoTab = deliverymanController.selectedTabIndex == 1;
        bool additionalInfoTab = deliverymanController.selectedTabIndex == 2;
        bool additionalDataExist = deliverymanController.additionalList!.isNotEmpty;

        return Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          appBar: isDesktop ? const WebMenuBar() : AppBar(
            title: Text( 'delivery_man_registration'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if(deliverymanController.selectedTabIndex == 2) {
                  deliverymanController.setSelectedTabIndex(1);
                }else if(deliverymanController.selectedTabIndex == 1) {
                  deliverymanController.setSelectedTabIndex(0);
                } else {
                  Get.back();
                }
              }
            ),
            backgroundColor: Theme.of(context).cardColor,
            surfaceTintColor: Theme.of(context).cardColor,
            shadowColor: Theme.of(context).disabledColor.withValues(alpha: 0.5),
            elevation: 2,
            actions: [SizedBox()],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall),
                  scrollDirection: Axis.horizontal,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    _tabButton(title: 'general_info'.tr, index: 0, isSelected: generalInfoTab, onTap: () {
                      deliverymanController.setSelectedTabIndex(0);
                    }),
                    SizedBox(width: Dimensions.paddingSizeSmall),

                    _tabButton(title: 'verification_info'.tr, index: 1, isSelected: verificationInfoTab, onTap: () {
                      if(_fNameController.text.isEmpty || _lNameController.text.isEmpty || _emailController.text.isEmpty || _phoneController.text.isEmpty
                          || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty || deliverymanController.pickedImage == null){
                        showCustomSnackBar('please_enter_all_required_fields'.tr, getXSnackBar: false);
                      }else{
                        deliverymanController.setSelectedTabIndex(1);
                      }
                    }),
                    SizedBox(width: Dimensions.paddingSizeSmall),

                    additionalDataExist ? _tabButton(title: 'additional_info'.tr, index: 2, isSelected: additionalInfoTab, onTap: () {
                      if(deliverymanController.selectedDmType == null || deliverymanController.selectedVehicleId == null || deliverymanController.selectedIdentityType == null
                          || deliverymanController.selectedDeliveryZoneId == null || _identityNumberController.text.isEmpty || deliverymanController.pickedIdentities.isEmpty) {
                        showCustomSnackBar('please_enter_all_required_fields'.tr, getXSnackBar: false);
                      }else {
                        deliverymanController.setSelectedTabIndex(2);
                      }
                    }) : SizedBox(),

                  ]),
                ),
              ),
            ),
          ),
          endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,

          body: SafeArea(
            child: GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanController) {
              return isDesktop ? DeliverymanRegistrationWebScreen(
                scrollController: _scrollController, fNameController: _fNameController, lNameController: _lNameController, emailController: _emailController,
                phoneController: _phoneController, passwordController: _passwordController, confirmPasswordController: _confirmPasswordController,
                identityNumberController: _identityNumberController, fNameNode: _fNameNode, lNameNode: _lNameNode, emailNode: _emailNode,
                phoneNode: _phoneNode, passwordNode: _passwordNode, confirmPasswordNode: _confirmPasswordNode, identityNumberNode: _identityNumberNode,
                buttonView: webButtonView()
              ) : Column(children: [

                generalInfoTab ? GeneralInfoTab(
                  deliverymanController: deliverymanController, fNameController: _fNameController, lNameController: _lNameController,
                  emailController: _emailController, phoneController: _phoneController, passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController, fNameNode: _fNameNode, lNameNode: _lNameNode, emailNode: _emailNode,
                  phoneNode: _phoneNode, passwordNode: _passwordNode, confirmPasswordNode: _confirmPasswordNode, infoFormKey: infoFormKey,
                ) : SizedBox(),

                verificationInfoTab ? VerificationInfoTab(
                  identityNumberController: _identityNumberController, identityNumberNode: _identityNumberNode,
                  additionalInfoTab: additionalInfoTab, additionalDataExist: additionalDataExist,
                ) : SizedBox(),

                additionalDataExist && additionalInfoTab ? AdditionalInfoTab(
                  deliverymanController: deliverymanController, scrollController: _scrollController,
                ) : SizedBox(),

                (isDesktop || ResponsiveHelper.isWeb()) ? const SizedBox() : buttonView(
                  generalInfoTab: generalInfoTab,
                  verificationInfoTab: verificationInfoTab,
                  additionalInfoTab: additionalInfoTab,
                  additionalDataExist: additionalDataExist,
                  isDesktop: isDesktop,
                ),

              ]);
            }),
          ),
        );
      }),
    );
  }

  Widget buttonView({required bool generalInfoTab, required bool verificationInfoTab, required bool additionalInfoTab, required bool additionalDataExist, required bool isDesktop}){
    return GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanController) {

      final progressValue = generalInfoTab ? 0.3 : verificationInfoTab ? 0.6 : 1.0;
      final progressValueWithOutAdditionalInfo = generalInfoTab ? 0.5 : 1.0;

      final buttonText = generalInfoTab ? 'next'.tr : verificationInfoTab ? 'next'.tr : 'submit'.tr;
      final buttonTextWithOutAdditionalInfo = generalInfoTab ? 'next'.tr : 'submit'.tr;

      return Column(
        children: [
          LinearProgressIndicator(
            backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.5), minHeight: 2,
            value: additionalDataExist ? progressValue : progressValueWithOutAdditionalInfo,
          ),

          Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
            ),
            child: CustomButtonWidget(
              fontSize: Dimensions.fontSizeLarge,
              isLoading: deliverymanController.isLoading,
              buttonText: additionalDataExist ? buttonText : buttonTextWithOutAdditionalInfo,
              onPressed: !deliverymanController.acceptTerms ? null : () async {

                String fName = _fNameController.text.trim();
                String lName = _lNameController.text.trim();
                String email = _emailController.text.trim();
                String phone = _phoneController.text.trim();
                String password = _passwordController.text.trim();
                String confirmPassword = _confirmPasswordController.text.trim();
                String identityNumber = _identityNumberController.text.trim();
                String numberWithCountryCode = deliverymanController.countryDialCode! + phone;
                PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
                numberWithCountryCode = phoneValid.phone;

                if(generalInfoTab){
                  if(infoFormKey!.currentState!.validate()) {
                    if(fName.isEmpty) {
                      showCustomSnackBar('enter_delivery_man_first_name'.tr);
                    }else if(lName.isEmpty) {
                      showCustomSnackBar('enter_delivery_man_last_name'.tr);
                    }else if(phone.isEmpty) {
                      showCustomSnackBar('enter_delivery_man_phone_number'.tr);
                    }else if(!phoneValid.isValid) {
                      showCustomSnackBar('enter_a_valid_phone_number'.tr);
                    }else if(email.isEmpty) {
                      showCustomSnackBar('enter_delivery_man_email_address'.tr);
                    }else if(!GetUtils.isEmail(email)) {
                      showCustomSnackBar('enter_a_valid_email_address'.tr);
                    }else if(password.isEmpty) {
                      showCustomSnackBar('enter_password_for_delivery_man'.tr);
                    }else if(password != confirmPassword) {
                      showCustomSnackBar('confirm_password_does_not_matched'.tr);
                    }else if(!deliverymanController.spatialCheck || !deliverymanController.lowercaseCheck || !deliverymanController.uppercaseCheck || !deliverymanController.numberCheck || !deliverymanController.lengthCheck) {
                      showCustomSnackBar('provide_valid_password'.tr);
                    }else if(deliverymanController.pickedImage == null) {
                      showCustomSnackBar('pick_delivery_man_profile_image'.tr);
                    }else {
                      deliverymanController.setSelectedTabIndex(1);
                    }
                  }
                }else if(verificationInfoTab) {
                  if(deliverymanController.selectedDmTypeId == null) {
                    showCustomSnackBar('please_select_deliveryman_type'.tr);
                  }else if(deliverymanController.selectedDeliveryZoneId == null) {
                    showCustomSnackBar('please_select_zone_for_the_deliveryman'.tr);
                  }else if(deliverymanController.selectedVehicleId == null) {
                    showCustomSnackBar('please_select_vehicle_for_the_deliveryman'.tr);
                  }else if(deliverymanController.selectedDmTypeId != 'salary_based' && deliverymanController.selectedShifts.isEmpty) {
                    showCustomSnackBar('please_select_shift_for_the_deliveryman'.tr);
                  }else if(deliverymanController.selectedIdentityType == null) {
                    showCustomSnackBar('please_select_identity_type_for_the_deliveryman'.tr);
                  }else if(identityNumber.isEmpty) {
                    showCustomSnackBar('enter_delivery_man_identity_number'.tr);
                  }else if(deliverymanController.pickedIdentities.isEmpty) {
                    showCustomSnackBar('please_select_identity_image'.tr);
                  }else {
                    if(additionalDataExist){
                      deliverymanController.setSelectedTabIndex(2);
                    }else{
                      Map<String, String> data = {};

                      data.addAll(DeliveryManBodyModel(
                        fName: fName, lName: lName, password: password, phone: numberWithCountryCode, email: email,
                        identityNumber: identityNumber, identityType: deliverymanController.selectedIdentityType,
                        earning: deliverymanController.selectedDmTypeId, zoneId: deliverymanController.selectedDeliveryZoneId,
                        vehicleId: deliverymanController.selectedVehicleId, shiftIds: deliverymanController.getSelectedShiftIds()
                      ).toJson());

                      if (kDebugMode) {
                        print('-------final data-- :  $data');
                      }

                      deliverymanController.registerDeliveryMan(data, [], []);
                    }
                  }
                }else{
                  bool customFieldEmpty = false;
                  Map<String, dynamic> additionalData = {};
                  List<FilePickerResult> additionalDocuments = [];
                  List<String> additionalDocumentsInputType = [];

                  for (DataModel data in deliverymanController.dataList!) {
                    bool isTextField = data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone';
                    bool isDate = data.fieldType == 'date';
                    bool isCheckBox = data.fieldType == 'check_box';
                    bool isFile = data.fieldType == 'file';
                    int index = deliverymanController.dataList!.indexOf(data);
                    bool isRequired = data.isRequired == 1;

                    if(isTextField) {
                      if (kDebugMode) {
                        print('=====check text field : ${deliverymanController.additionalList![index].text == ''}');
                      }
                      if(deliverymanController.additionalList![index].text != '') {
                        additionalData.addAll({data.inputData! : deliverymanController.additionalList![index].text});
                      } else {
                        if(isRequired) {
                          customFieldEmpty = true;
                          showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
                          break;
                        }
                      }
                    } else if(isDate) {
                      if (kDebugMode) {
                        print('---check date : ${deliverymanController.additionalList![index]}');
                      }
                      if(deliverymanController.additionalList![index] != null) {
                        additionalData.addAll({data.inputData! : deliverymanController.additionalList![index]});
                      } else {
                        if(isRequired) {
                          customFieldEmpty = true;
                          showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
                          break;
                        }
                      }
                    } else if(isCheckBox) {
                      List<String> checkData = [];
                      bool noNeedToGoElse = false;
                      for(var e in deliverymanController.additionalList![index]) {
                        if(e != 0) {
                          checkData.add(e);
                          customFieldEmpty = false;
                          noNeedToGoElse = true;
                        } else if(!noNeedToGoElse) {
                          customFieldEmpty = true;
                        }
                      }
                      if(customFieldEmpty && isRequired) {
                        showCustomSnackBar( '${'please_set_data_in'.tr} ${deliverymanController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase()} ${'field'.tr}');
                        break;
                      } else {
                        additionalData.addAll({data.inputData! : checkData});
                      }

                    } else if(isFile) {
                      if (kDebugMode) {
                        print('---check file : ${deliverymanController.additionalList![index]}');
                      }
                      if(deliverymanController.additionalList![index].length == 0 && isRequired) {
                        customFieldEmpty = true;
                        showCustomSnackBar('${'please_add'.tr} ${deliverymanController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase()}');
                        break;
                      } else {
                        deliverymanController.additionalList![index].forEach((file) {
                          additionalDocuments.add(file);
                          additionalDocumentsInputType.add(deliverymanController.dataList![index].inputData!);
                        });
                      }
                    }
                  }

                  if(!customFieldEmpty) {
                    Map<String, String> data = {};

                    data.addAll(DeliveryManBodyModel(
                      fName: fName, lName: lName, password: password, phone: numberWithCountryCode, email: email,
                      identityNumber: identityNumber, identityType: deliverymanController.selectedIdentityType,
                      earning: deliverymanController.selectedDmTypeId, zoneId: deliverymanController.selectedDeliveryZoneId,
                      vehicleId: deliverymanController.selectedVehicleId, shiftIds: deliverymanController.getSelectedShiftIds()
                    ).toJson());

                    data.addAll({
                      'additional_data': jsonEncode(additionalData),
                    });

                    if (kDebugMode) {
                      print('-------final data-- :  $data');
                    }

                    deliverymanController.registerDeliveryMan(data, additionalDocuments, additionalDocumentsInputType);
                  }
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Widget webButtonView(){
    return GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanController) {
      return CustomButtonWidget(
        isBold: false,
        fontSize: Dimensions.fontSizeSmall,
        isLoading: deliverymanController.isLoading,
        buttonText: 'submit'.tr,
        onPressed: !deliverymanController.acceptTerms ? null : () async {

          String fName = _fNameController.text.trim();
          String lName = _lNameController.text.trim();
          String email = _emailController.text.trim();
          String phone = _phoneController.text.trim();
          String password = _passwordController.text.trim();
          String confirmPassword = _confirmPasswordController.text.trim();
          String identityNumber = _identityNumberController.text.trim();
          String numberWithCountryCode = deliverymanController.countryDialCode! + phone;
          PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
          numberWithCountryCode = phoneValid.phone;

          if(fName.isEmpty) {
            showCustomSnackBar('enter_delivery_man_first_name'.tr);
          }else if(lName.isEmpty) {
            showCustomSnackBar('enter_delivery_man_last_name'.tr);
          }else if(deliverymanController.pickedImage == null) {
            showCustomSnackBar('pick_delivery_man_profile_image'.tr);
          }else if(email.isEmpty) {
            showCustomSnackBar('enter_delivery_man_email_address'.tr);
          }else if(!GetUtils.isEmail(email)) {
            showCustomSnackBar('enter_a_valid_email_address'.tr);
          }else if(deliverymanController.selectedDmTypeId == null) {
            showCustomSnackBar('please_select_deliveryman_type'.tr);
          }else if(deliverymanController.selectedDeliveryZoneId == null) {
            showCustomSnackBar('please_select_zone_for_the_deliveryman'.tr);
          }else if(deliverymanController.selectedVehicleId == null) {
            showCustomSnackBar('please_select_vehicle_for_the_deliveryman'.tr);
          }else if(deliverymanController.selectedIdentityType == null) {
            showCustomSnackBar('please_select_identity_type_for_the_deliveryman'.tr);
          }else if(identityNumber.isEmpty) {
            showCustomSnackBar('enter_delivery_man_identity_number'.tr);
          }else if(deliverymanController.pickedIdentities.isEmpty) {
            showCustomSnackBar('please_select_identity_image'.tr);
          }else if(phone.isEmpty) {
            showCustomSnackBar('enter_delivery_man_phone_number'.tr);
          }else if(!phoneValid.isValid) {
            showCustomSnackBar('enter_a_valid_phone_number'.tr);
          }else if(password.isEmpty) {
            showCustomSnackBar('enter_password_for_delivery_man'.tr);
          }else if(password != confirmPassword) {
            showCustomSnackBar('confirm_password_does_not_matched'.tr);
          }else if(!deliverymanController.spatialCheck || !deliverymanController.lowercaseCheck || !deliverymanController.uppercaseCheck || !deliverymanController.numberCheck || !deliverymanController.lengthCheck) {
            showCustomSnackBar('provide_valid_password'.tr);
          }else{
            bool customFieldEmpty = false;
            Map<String, dynamic> additionalData = {};
            List<FilePickerResult> additionalDocuments = [];
            List<String> additionalDocumentsInputType = [];

            for (DataModel data in deliverymanController.dataList!) {
              bool isTextField = data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone';
              bool isDate = data.fieldType == 'date';
              bool isCheckBox = data.fieldType == 'check_box';
              bool isFile = data.fieldType == 'file';
              int index = deliverymanController.dataList!.indexOf(data);
              bool isRequired = data.isRequired == 1;

              if(isTextField) {
                if (kDebugMode) {
                  print('=====check text field : ${deliverymanController.additionalList![index].text == ''}');
                }
                if(deliverymanController.additionalList![index].text != '') {
                  additionalData.addAll({data.inputData! : deliverymanController.additionalList![index].text});
                } else {
                  if(isRequired) {
                    customFieldEmpty = true;
                    showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
                    break;
                  }
                }
              } else if(isDate) {
                if (kDebugMode) {
                  print('---check date : ${deliverymanController.additionalList![index]}');
                }
                if(deliverymanController.additionalList![index] != null) {
                  additionalData.addAll({data.inputData! : deliverymanController.additionalList![index]});
                } else {
                  if(isRequired) {
                    customFieldEmpty = true;
                    showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
                    break;
                  }
                }
              } else if(isCheckBox) {
                List<String> checkData = [];
                bool noNeedToGoElse = false;
                for(var e in deliverymanController.additionalList![index]) {
                  if(e != 0) {
                    checkData.add(e);
                    customFieldEmpty = false;
                    noNeedToGoElse = true;
                  } else if(!noNeedToGoElse) {
                    customFieldEmpty = true;
                  }
                }
                if(customFieldEmpty && isRequired) {
                  showCustomSnackBar( '${'please_set_data_in'.tr} ${deliverymanController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase()} ${'field'.tr}');
                  break;
                } else {
                  additionalData.addAll({data.inputData! : checkData});
                }

              } else if(isFile) {
                if (kDebugMode) {
                  print('---check file : ${deliverymanController.additionalList![index]}');
                }
                if(deliverymanController.additionalList![index].length == 0 && isRequired) {
                  customFieldEmpty = true;
                  showCustomSnackBar('${'please_add'.tr} ${deliverymanController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase()}');
                  break;
                } else {
                  deliverymanController.additionalList![index].forEach((file) {
                    additionalDocuments.add(file);
                    additionalDocumentsInputType.add(deliverymanController.dataList![index].inputData!);
                  });
                }
              }
            }

            if(!customFieldEmpty) {
              Map<String, String> data = {};

              data.addAll(DeliveryManBodyModel(
                fName: fName, lName: lName, password: password, phone: numberWithCountryCode, email: email,
                identityNumber: identityNumber, identityType: deliverymanController.selectedIdentityType,
                earning: deliverymanController.selectedDmTypeId, zoneId: deliverymanController.selectedDeliveryZoneId,
                vehicleId: deliverymanController.selectedVehicleId, shiftIds: deliverymanController.getSelectedShiftIds()
              ).toJson());

              data.addAll({
                'additional_data': jsonEncode(additionalData),
              });

              if (kDebugMode) {
                print('-------final data-- :  $data');
              }

              deliverymanController.registerDeliveryMan(data, additionalDocuments, additionalDocumentsInputType);
            }
          }
        },
      );
    });
  }

  Widget _tabButton({required String title, required int index, bool isSelected = false, required Function() onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            title.tr,
            style: robotoRegular.copyWith(color: isSelected ? Theme.of(context).cardColor : Theme.of(context).hintColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }
}

class GeneralInfoTab extends StatefulWidget {
  final DeliverymanRegistrationController deliverymanController;
  final TextEditingController fNameController;
  final TextEditingController lNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode fNameNode;
  final FocusNode lNameNode;
  final FocusNode phoneNode;
  final FocusNode emailNode;
  final FocusNode passwordNode;
  final FocusNode confirmPasswordNode;
  final GlobalKey<FormState>? infoFormKey;
  const GeneralInfoTab({super.key, required this.deliverymanController, required this.fNameController, required this.lNameController, required this.phoneController,
    required this.emailController, required this.passwordController, required this.confirmPasswordController, required this.fNameNode, required this.lNameNode,
    required this.phoneNode, required this.emailNode, required this.passwordNode, required this.confirmPasswordNode, this.infoFormKey});

  @override
  State<GeneralInfoTab> createState() => _GeneralInfoTabState();
}

class _GeneralInfoTabState extends State<GeneralInfoTab> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 0)],
          ),
          child: Form(
            key: widget.infoFormKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('general_info'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text('general_info_subtitle'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
              SizedBox(height: Dimensions.paddingSizeDefault),

              CustomTextFieldWidget(
                titleText: 'write_first_name'.tr,
                controller: widget.fNameController,
                capitalization: TextCapitalization.words,
                inputType: TextInputType.name,
                focusNode: widget.fNameNode,
                nextFocus: widget.lNameNode,
                labelText: 'first_name'.tr,
                required: true,
                validator: (value) => ValidateCheck.validateEmptyText(value, "first_name_field_is_required".tr),
              ),
              const SizedBox(height: Dimensions.paddingSizeOverLarge),

              CustomTextFieldWidget(
                titleText: 'write_last_name'.tr,
                controller: widget.lNameController,
                capitalization: TextCapitalization.words,
                inputType: TextInputType.name,
                focusNode: widget.lNameNode,
                nextFocus: widget.phoneNode,
                labelText: 'last_name'.tr,
                required: true,
                validator: (value) => ValidateCheck.validateEmptyText(value, "last_name_field_is_required".tr),
              ),
              const SizedBox(height: Dimensions.paddingSizeOverLarge),

              CustomTextFieldWidget(
                titleText: 'write_phone_number'.tr,
                controller: widget.phoneController,
                focusNode: widget.phoneNode,
                nextFocus: widget.emailNode,
                inputType: TextInputType.phone,
                isPhone: true,
                onCountryChanged: (CountryCode countryCode) {
                  widget.deliverymanController.setCountryDialCode(countryCode.dialCode);
                },
                countryDialCode: widget.deliverymanController.countryDialCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode,
                labelText: 'phone'.tr,
                required: true,
                validator: (value) => ValidateCheck.validatePhone(value, null),
              ),
              const SizedBox(height: Dimensions.paddingSizeOverLarge),

              CustomTextFieldWidget(
                titleText: 'write_email'.tr,
                controller: widget.emailController,
                focusNode: widget.emailNode,
                nextFocus: widget.passwordNode,
                inputType: TextInputType.emailAddress,
                labelText: 'email'.tr,
                required: true,
                validator: (value) => ValidateCheck.validateEmail(value),
              ),
              const SizedBox(height: Dimensions.paddingSizeOverLarge),

              CustomTextFieldWidget(
                titleText: '8+characters'.tr,
                controller: widget.passwordController,
                focusNode: widget.passwordNode,
                nextFocus: widget.confirmPasswordNode,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
                onChanged: (value){
                  if(value != null && value.isNotEmpty){
                    if(!widget.deliverymanController.showPassView){
                      widget.deliverymanController.showHidePassView();
                    }
                    widget.deliverymanController.validPassCheck(value);
                  }else{
                    if(widget.deliverymanController.showPassView){
                      widget.deliverymanController.showHidePassView();
                    }
                  }
                },
                labelText: 'password'.tr,
                required: true,
                validator: (value) => ValidateCheck.validateEmptyText(value, "enter_password_for_delivery_man".tr),
              ),

              widget.deliverymanController.showPassView ? const PassViewWidget() : const SizedBox(),
              const SizedBox(height: Dimensions.paddingSizeOverLarge),

              CustomTextFieldWidget(
                titleText: '8+characters'.tr,
                hintText: '',
                controller: widget.confirmPasswordController,
                focusNode: widget.confirmPasswordNode,
                inputAction: TextInputAction.done,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
                labelText: 'confirm_password'.tr,
                required: true,
                validator: (value) => ValidateCheck.validateConfirmPassword(value, widget.passwordController.text),
              ),
              const SizedBox(height: Dimensions.paddingSizeOverLarge),

              Container(
                width: context.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(children: [
                    Text('deliveryman_image'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(' *', style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red)),
                  ]),

                  Text(
                    'identity_image_ratio'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Align(
                    alignment: Alignment.center,
                    child: Stack(clipBehavior: Clip.none, children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: widget.deliverymanController.pickedImage != null ? GetPlatform.isWeb ? Image.network(
                          widget.deliverymanController.pickedImage!.path, width: 120, height: 120, fit: BoxFit.cover,
                        ) : Image.file(
                          File(widget.deliverymanController.pickedImage!.path), width: 120, height: 120, fit: BoxFit.cover,
                        ) : Container(
                          width: 120, height: 120,
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
                          onTap: () => widget.deliverymanController.pickDmImage(true, false),
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

                      widget.deliverymanController.pickedImage != null ? Positioned(
                        bottom: -10, right: -10,
                        child: InkWell(
                          onTap: () => widget.deliverymanController.removeDmImage(),
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

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ]),
              ),

            ]),
          ),
        ),
      ),
    );
  }
}

class VerificationInfoTab extends StatefulWidget {
  final TextEditingController identityNumberController;
  final FocusNode identityNumberNode;
  final bool additionalInfoTab;
  final bool additionalDataExist;
  const VerificationInfoTab({super.key, required this.identityNumberController, required this.identityNumberNode, required this.additionalInfoTab, required this.additionalDataExist});

  @override
  State<VerificationInfoTab> createState() => _VerificationInfoTabState();
}

class _VerificationInfoTabState extends State<VerificationInfoTab> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanController) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 0)],
              ),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text('verification_info'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text('verification_info_subtitle'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                SizedBox(height: Dimensions.paddingSizeLarge),

                Stack(clipBehavior: Clip.none, children: [
                  CustomDropdownButton(
                    hintText: 'deliveryMan_type'.tr,
                    items: deliverymanController.dmTypeList,
                    selectedValue: deliverymanController.selectedDmType,
                    onChanged: (value) {
                      deliverymanController.setDeliverymanType(value);
                      deliverymanController.setSelectedDmType(value);
                    },
                  ),

                  Positioned(
                    left: 10, top: -10,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(2),
                      child: Row(children: [
                        Text('select_delivery_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                        Text(' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                      ]),
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeOverLarge),

                deliverymanController.zoneList != null ? deliverymanController.zoneList!.isNotEmpty ? Stack(clipBehavior: Clip.none, children: [
                  CustomDropdownButton(
                    hintText: 'select_delivery_zone'.tr,
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
                    left: 10, top: -10,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(2),
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
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                deliverymanController.vehicles != null ? deliverymanController.vehicles!.isNotEmpty ? Stack(clipBehavior: Clip.none, children: [
                  CustomDropdownButton(
                    hintText: 'select_vehicle_type'.tr,
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
                    left: 10, top: -10,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(2),
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
                const SizedBox(height: Dimensions.paddingSizeOverLarge),

                (deliverymanController.selectedDmType == 'freelancer') ?
                  (deliverymanController.shifts != null && deliverymanController.shifts!.isNotEmpty) ?
                   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(clipBehavior: Clip.none, children: [
                          CustomDropdownButton(
                            hintText: 'working_shift'.tr,
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
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Theme.of(context).disabledColor.withValues(alpha: 0.07) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
                                  child: Text(
                                    '${shift.name} (${DateConverter.timeStringToTime(shift.startTime!)} - ${DateConverter.timeStringToTime(shift.endTime!)})',
                                    style: isSelected
                                        ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)
                                        : robotoRegular.copyWith(
                                      color: shouldDisable ? Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.4) : Theme.of(context).textTheme.bodyLarge?.color,
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

                          Positioned(left: 10, top: -10,
                            child: Container(
                              color: Theme.of(context).cardColor,
                              padding: const EdgeInsets.all(2),
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
                            Wrap(spacing: 5, runSpacing: 0, alignment: WrapAlignment.start, children: List.generate(
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
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 3),
                                    );
                                  }),
                            )]
                        ) : SizedBox.shrink(),

                        const SizedBox(height: Dimensions.paddingSizeOverLarge),
                      ]
                  ) : SizedBox.shrink() : SizedBox.shrink(),



                Stack(clipBehavior: Clip.none, children: [
                  CustomDropdownButton(
                    hintText: 'select_identity_type'.tr,
                    items: deliverymanController.identityTypeList,
                    selectedValue: deliverymanController.selectedIdentityType,
                    onChanged: (value) {
                      deliverymanController.setSelectedIdentityType(value);
                    },
                  ),

                  Positioned(
                    left: 10, top: -10,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(2),
                      child: Row(children: [
                        Text('select_identity_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                        Text(' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                      ]),
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeOverLarge),

                CustomTextFieldWidget(
                  titleText: 'Ex: XXXXX-XXXXXXX-X',
                  controller: widget.identityNumberController,
                  focusNode: widget.identityNumberNode,
                  inputAction: TextInputAction.done,
                  labelText: 'identity_number'.tr,
                  required: true,
                  isEnabled: deliverymanController.selectedIdentityType != null,
                  fromDeliveryRegistration: true,

                  validator: (value) => ValidateCheck.validateEmptyText(value, "identity_number_field_is_required".tr),
                ),
                const SizedBox(height: Dimensions.paddingSizeOverLarge),

                Container(
                  width: context.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Row(
                      children: [
                        Text('upload_identity_image'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        Text(' *', style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red)),
                      ],
                    ),

                    Text(
                      'upload_identity_image_ratio'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: deliverymanController.pickedIdentities.length + 1,
                      itemBuilder: (context, index) {
                        XFile? file = index == deliverymanController.pickedIdentities.length ? null : deliverymanController.pickedIdentities[index];
                        if(index < 5 && index == deliverymanController.pickedIdentities.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                            child: InkWell(
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
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  ),
                                  height: 70, width: double.infinity,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    CustomAssetImageWidget(Images.pictureIcon, width: 25, height: 25, fit: BoxFit.cover),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    Text(
                                      'click_to_add'.tr,
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue), textAlign: TextAlign.center,
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          );
                        }
                        return file != null ? Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeExtraLarge, right: Dimensions.paddingSizeExtraLarge),
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
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: GetPlatform.isWeb ? Image.network(
                                  file.path, width: double.infinity, height: 70, fit: BoxFit.cover,
                                ) : Image.file(
                                  File(file.path), width: double.infinity, height: 70, fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 5, top: 5,
                                child: InkWell(
                                  onTap: () => deliverymanController.removeIdentityImage(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      border: Border.all(color: Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    ),
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    child: const Icon(CupertinoIcons.trash, color: Colors.red, size: 16),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ) : const SizedBox();
                      },
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ]),
                ),
              ]),
            ),

            widget.additionalDataExist ? SizedBox() : Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              child: TramsConditionsCheckBoxWidget(deliverymanRegistrationController: deliverymanController, fromDmRegistration: true),
            ),
          ]),
        ),
      );
    });
  }
}

class AdditionalInfoTab extends StatelessWidget {
  final DeliverymanRegistrationController deliverymanController;
  final ScrollController scrollController;
  const AdditionalInfoTab({super.key, required this.deliverymanController, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          DeliverymanAdditionalDataSectionWidget(deliverymanController: deliverymanController, scrollController: scrollController),

          TramsConditionsCheckBoxWidget(deliverymanRegistrationController: deliverymanController, fromDmRegistration: true),
        ]),
      ),
    );
  }
}
