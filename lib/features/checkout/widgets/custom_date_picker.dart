import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatelessWidget {
  final String hint;
  final DateTimeRange? range;
  final Function(DateTimeRange range) onDatePicked;
  final bool isPause;
  const CustomDatePicker({super.key, required this.hint, required this.range, required this.onDatePicked, this.isPause = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {

        DateTimeRange? pickedRange = await showDialog<DateTimeRange?>(
          context: context,
          builder: (context) {
            PickerDateRange? selectedRange;

            final firstDate = isPause ? DateTime.now().add(Duration(days: 1)) : DateTime.now();

            final lastDate = isPause
                ? DateTime.parse(Get.find<OrderController>().trackModel!.subscription!.endAt!)
                : DateTime.now().add(const Duration(days: 365));

            return Dialog(
              insetPadding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
              child: Container(
                width: ResponsiveHelper.isDesktop(context) ? 400 : context.width * 0.85,
                height: ResponsiveHelper.isDesktop(context) ? context.height * 0.85 : context.height * 0.60,
                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: SfDateRangePicker(
                  minDate: firstDate,
                  maxDate: lastDate,
                  selectionMode: DateRangePickerSelectionMode.range,
                  cancelText: 'cancel'.tr,
                  confirmText: 'submit'.tr,
                  backgroundColor: Theme.of(context).cardColor,
                  showActionButtons: true,
                  onSelectionChanged: (args) {
                    if (args.value is PickerDateRange) {
                      selectedRange = args.value;
                      debugPrint(selectedRange.toString());
                    }
                  },
                  onSubmit: (val) {
                    if (val is PickerDateRange) {
                      final start = val.startDate!;
                      final end = val.endDate ?? val.startDate!;
                      Navigator.pop(context, DateTimeRange(start: start, end: end));
                    } else {
                      Navigator.pop(context, null);
                    }
                  },
                  onCancel: () {
                    Navigator.pop(context, null);
                  },
                ),
              ),
            );
          },
        );

        if(pickedRange != null) {
          if(pickedRange.start == pickedRange.end){
            showCustomSnackBar('start_date_and_end_date_can_not_be_same_for_subscription_order'.tr);
          }else{
            onDatePicked(pickedRange);
          }
        }
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.3),
        ),
        child: Row(children: [
          Expanded(
            child: Text(
              range != null ? DateConverter.dateRangeToDate(range!) : hint,
              style: robotoRegular,
            ),
          ),

          Icon(Icons.date_range_rounded, size: 24, color: range != null ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
        ]),
      ),
    );
  }
}
