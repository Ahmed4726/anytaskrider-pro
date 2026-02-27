import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class CustomDropdownButton<T> extends StatefulWidget {
  final List<String>? items;
  final bool showTitle;
  final bool isBorder;
  final String? hintText;
  final double? borderRadius;
  final Color? backgroundColor;
  final Function(T?)? onChanged;
  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T>? onSaved;
  final FontWeight? titleFontWeight;
  final T? selectedValue;
  final List<DropdownMenuItem<T>>? dropdownMenuItems;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final Widget? prefixIcon;

  const CustomDropdownButton({super.key, this.items, this.showTitle = true, this.isBorder = true, this.hintText, this.borderRadius,
    this.backgroundColor, this.onChanged, this.validator, this.onSaved, this.titleFontWeight, this.selectedValue,
    this.dropdownMenuItems, this.selectedItemBuilder, this.prefixIcon});

  @override
  State<CustomDropdownButton<T>> createState() => _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? Dimensions.radiusDefault),
      ),
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        decoration: InputDecoration(
          prefix: Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 5),
            child: widget.prefixIcon,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          focusedBorder: _border(),
          enabledBorder: _border(),
          disabledBorder: _border(),
          focusedErrorBorder: _border(),
          errorBorder: _border(),
        ),
        hint: Text(widget.hintText ?? 'select_an_option'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault)),
        value: widget.selectedValue,
        items: (widget.dropdownMenuItems ?? widget.items?.map((item) => DropdownMenuItem<T>(
          value: item as T,
          child: Text(item.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault)),
        )).toList()) ?? [
          DropdownMenuItem<T>(
            value: null,
            child: Text('no_data_available'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault),
            ),
          )
        ],
        validator: widget.validator ?? (value) {
          if (value == null) {
            return 'please_select_an_option'.tr;
          }
          return null;
        },
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        selectedItemBuilder: widget.selectedItemBuilder,
        buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
        iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).disabledColor)),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: widget.prefixIcon != null ? 0 : 5)),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? Dimensions.radiusDefault)),
      borderSide: BorderSide(width: 1, color: widget.isBorder ? Theme.of(context).disabledColor.withValues(alpha: 0.2) : Colors.transparent),
    );
  }
}