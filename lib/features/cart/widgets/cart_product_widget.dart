import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/helper/cart_helper.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/common/widgets/quantity_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class CartProductWidget extends StatefulWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  final bool isRestaurantOpen;
  const CartProductWidget({super.key, required this.cart, required this.cartIndex, required this.isAvailable, required this.addOns, required this.isRestaurantOpen});

  @override
  State<CartProductWidget> createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget> {
  bool showAddonsVariations = false;

  @override
  Widget build(BuildContext context) {
    String addOnText = CartHelper.setupAddonsText(cart: widget.cart) ?? '';
    String variationText = CartHelper.setupVariationText(cart: widget.cart).$1;

    double? discount = widget.cart.product!.discount;
    String? discountType = widget.cart.product!.discountType;

    int addonCount = widget.cart.addOnIds?.length ?? 0;
    int variationCount = CartHelper.setupVariationText(cart: widget.cart).$2;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault),
          child: GetBuilder<CartController>(
            builder: (cartController) {
              return Slidable(
                key: UniqueKey(),
                enabled: !cartController.isLoading,
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.2,
                  children: [
                    SlidableAction(
                      onPressed: (context) => cartController.removeFromCart(widget.cartIndex),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(Get.find<LocalizationController>().isLtr ? Dimensions.radiusDefault : 0), left: Radius.circular(Get.find<LocalizationController>().isLtr ? 0 : Dimensions.radiusDefault)),
                      foregroundColor: Colors.white,
                      icon: CupertinoIcons.trash,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: ResponsiveHelper.isDesktop(context) ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: CustomInkWellWidget(
                    onTap: (){
                      ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (con) => ProductBottomSheetWidget(product: widget.cart.product, cartIndex: widget.cartIndex, cart: widget.cart),
                      ).then((value) => Get.find<CartController>().getCartDataOnline(),
                      ) : showDialog(context: context, builder: (con) => Dialog(
                        child: ProductBottomSheetWidget(product: widget.cart.product, cartIndex: widget.cartIndex, cart: widget.cart),
                      )).then((value) => Get.find<CartController>().getCartDataOnline());
                    },
                    radius: Dimensions.radiusDefault,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            widget.cart.product!.imageFullUrl != null ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  child: CustomImageWidget(
                                    image: '${widget.cart.product!.imageFullUrl}',
                                    height: 60, width: 60, fit: BoxFit.cover, isFood: true,
                                  ),
                                ),
                                widget.isAvailable ? const SizedBox() : Positioned(
                                  top: 0, left: 0, bottom: 0, right: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.black.withValues(alpha: 0.6)),
                                    child: Text('not_available_now_break'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                                      color: Colors.white, fontSize: 8,
                                    )),
                                  ),
                                ),
                              ],
                            ) : const SizedBox(),
                            SizedBox(width: widget.cart.product!.imageFullUrl != null ? Dimensions.paddingSizeSmall : 0),

                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                Row(children: [
                                  Flexible(
                                    child: Text(
                                      widget.cart.product!.name!,
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  CustomAssetImageWidget(
                                    widget.cart.product!.veg == 0 ? Images.nonVegImage : Images.vegImage,
                                    height: 11, width: 11,
                                  ),

                                  SizedBox(width: widget.cart.product!.isRestaurantHalalActive! && widget.cart.product!.isHalalFood! ? Dimensions.paddingSizeExtraSmall : 0),

                                  widget.cart.product!.isRestaurantHalalActive! && widget.cart.product!.isHalalFood! ? const CustomAssetImageWidget(
                                   Images.halalIcon, height: 13, width: 13) : const SizedBox(),

                                ]),
                                const SizedBox(height: 5),

                                Wrap(
                                  children: [
                                    Text(
                                      PriceConverter.convertPrice(widget.cart.product!.price, discount: discount, discountType: discountType),
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                                    ),
                                    SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                                    discount > 0 ? Text(
                                      PriceConverter.convertPrice(widget.cart.product!.price), textDirection: TextDirection.ltr,
                                      style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough),
                                    ) : const SizedBox(),
                                  ],
                                ),

                                addOnText.isNotEmpty || variationText.isNotEmpty ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      showAddonsVariations = !showAddonsVariations;
                                    });
                                  },
                                  child: Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
                                    Text('${variationCount > 0 ? '$variationCount ${'variations'.tr}' : ''}'
                                        '${addonCount > 0 ? ', $addonCount ${'addons'.tr}' : ''}',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade200,
                                      ),
                                      child: Icon(
                                        showAddonsVariations ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                                        size: 20, color: showAddonsVariations ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                      ),
                                    ),
                                  ]),
                                ) : const SizedBox(),

                              ]),
                            ),

                            GetBuilder<CartController>(builder: (cartController) {
                              return Padding(
                                padding: EdgeInsets.only(top: widget.cart.product!.imageFullUrl == null ? Dimensions.paddingSizeSmall-2 : Dimensions.paddingSizeDefault+2),
                                child: Row(children: [

                                  QuantityButton(
                                    onTap: cartController.isLoading ? () {} : () {
                                      if (widget.cart.quantity! > 1) {
                                        cartController.setQuantity(false, widget.cart);
                                      }else {
                                        cartController.removeFromCart(widget.cartIndex);
                                      }
                                    },
                                    isIncrement: false,
                                    showRemoveIcon: widget.cart.quantity! == 1,
                                  ),

                                   Container(
                                     padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                       border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                                     ),
                                     child: AnimatedFlipCounter(
                                      duration: const Duration(milliseconds: 500),
                                      value: widget.cart.quantity!.toDouble(),
                                      textStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                                     ),
                                   ),

                                  QuantityButton(
                                    onTap: cartController.isLoading ? (){} : () => cartController.setQuantity(true, widget.cart),
                                    isIncrement: true,
                                    color: cartController.isLoading ? Theme.of(context).disabledColor : null,
                                  ),
                                ]),
                              );
                            }),

                          ]),

                          if(showAddonsVariations)
                            Padding(
                              padding: EdgeInsets.only(left: ResponsiveHelper.isDesktop(context) ? 100 : 70),
                              child: Column(children: [
                                addOnText.isNotEmpty ? Padding(
                                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                                  child: Row(children: [
                                    Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                    Flexible(child: Text(
                                      addOnText,
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                    )),
                                  ]),
                                ) : const SizedBox(),

                                variationText.isNotEmpty ? Padding(
                                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                    Flexible(child: Text(
                                      variationText,
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                    )),
                                  ]),
                                ) : const SizedBox(),
                              ]),
                            ),


                          ResponsiveHelper.isDesktop(context) ? const Padding(
                            padding: EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                            child: Divider(),
                          ) : const SizedBox()

                        ],
                      ),
                    ),
                  )
                ),
              );
            }
          ),
        ),

        widget.isRestaurantOpen ? const SizedBox() : Positioned(
          left: 0, right: 0, bottom: 0, top: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.radiusDefault),
              color: Theme.of(context).disabledColor.withValues(alpha: ResponsiveHelper.isDesktop(context) ? 0.1 : 0.3),
            ),
            margin: EdgeInsets.only(bottom: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault),
          ),
        )
      ],
    );
  }
}

