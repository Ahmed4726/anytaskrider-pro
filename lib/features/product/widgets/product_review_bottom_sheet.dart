import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/readmore_widget.dart';
import 'package:stackfood_multivendor/features/review/widgets/rating_widget.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class ProductReviewBottomSheet extends StatelessWidget {
  final Product product;
  const ProductReviewBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.isDesktop(context) ? 550 : MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20),
          bottomLeft: Radius.circular(ResponsiveHelper.isDesktop(context) ? 20 : 0), bottomRight: Radius.circular(ResponsiveHelper.isDesktop(context) ? 20 : 0),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const SizedBox(width: 20),

          Container(
            height: 5, width: 35,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
            child: InkWell(
              onTap: () {
                Get.back();
                ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                  ProductBottomSheetWidget(product: product, isCampaign: false, fromReview: true),
                  backgroundColor: Colors.transparent, isScrollControlled: true,
                ) : Get.dialog(
                  Dialog(child: ProductBottomSheetWidget(product: product, isCampaign: false, fromReview: true)),
                );
              },
              child: Icon(Icons.close, color: Theme.of(context).disabledColor.withValues(alpha: 0.6), size: 22),
            ),
          ),
        ]),

        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
              child: Column(children: [

                Text(product.name ?? '', style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text('${product.reviewCount} ${'reviews'.tr}', style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
                SizedBox(height: Dimensions.paddingSizeLarge),

                RatingWidget(averageRating: product.avgRating ?? 0, ratingCount: product.ratingCount ?? 0, reviewCommentCount: product.reviewCount ?? 0, ratings: product.ratings),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                ListView.builder(
                  itemCount: product.reviews!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text(product.reviews?[index].userName ?? '', style: robotoSemiBold),
                        SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        RatingBarWidget(rating: product.avgRating, size: 15, ratingCount: null, reviewCount: null),
                        SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(DateConverter.stringDateTimeToDate(product.reviews![index].createdAt!), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                        SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        ReadMoreText(
                          product.reviews?[index].comment ?? '',
                          style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7)),
                          trimMode: TrimMode.Line,
                          trimLines: 3,
                          colorClickableText: Theme.of(context).primaryColor,
                          lessStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                          trimCollapsedText: 'show_more'.tr,
                          trimExpandedText: ' ${'show_less'.tr}',
                          moreStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                        ),

                      ]),
                    );
                  },
                ),

              ]),
            ),
          ),
        ),

      ]),

    );
  }
}
