import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class MessageCardWidget extends StatelessWidget {
  final String userTypeImage;
  final String userType;
  final String message;
  final String time;
  final Function()? onTap;
  final bool isUnread;
  final int count;
  const MessageCardWidget({super.key, required this.userTypeImage, required this.userType, required this.message, required this.time,
    this.onTap, this.isUnread = false, required this.count});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      isBorder: false,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipOval(
            child: CustomImageWidget(height: 50, width: 50, image: userTypeImage,
          )),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              Flexible(
                child: Row(
                  children: [
                    Flexible(child: Text(userType, style: robotoMedium, maxLines: 2, overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                      ),
                      child: Text(
                        'admin'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Align(
                alignment: Alignment.centerRight,
                child: Text(time, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              message, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Align(
              alignment: Alignment.centerRight,
              child: count > 0 ? Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Text(count.toString(), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor)),
              ) : const SizedBox(height: 15),
            ),

          ])),
        ]),
      ),
    );
  }
}
