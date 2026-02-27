import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class BottomSheetViewWidget extends StatelessWidget {
  const BottomSheetViewWidget({super.key});

  @override
  Widget build(BuildContext context) {

    bool isDeskTop = ResponsiveHelper.isDesktop(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(isDeskTop ? 20 : 0)),
      ),
      child: Stack(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

            isDeskTop ? SizedBox() : Center(
              child: Container(
                height: 5, width: 40,
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
              child: Row(children: [
                const Icon(Icons.error_outline, size: 20, color: Colors.blue),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text('how_it_works'.tr , style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.blue), textAlign: TextAlign.center),
              ]),
            ),

            ListView.builder(
              shrinkWrap: true,
              padding:  EdgeInsets.only(
                left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, bottom: isDeskTop ? 0 : Dimensions.paddingSizeOverLarge,
                top: isDeskTop ? Dimensions.paddingSizeDefault : 0,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppConstants.dataList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall) ,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.07), shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.blue[50]!, blurRadius: 1)],
                      ),
                      child: Text('${index+1}'),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text(AppConstants.dataList[index].tr, style: robotoRegular),
                  ]),
                );
              },
            ),
          ]),

          isDeskTop ? SizedBox() : Positioned(
            top: 0, right: 0,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.clear, color: Theme.of(context).disabledColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
