import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/product/custom_order_products_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class CustomOrderDetailScreen extends StatelessWidget {
  const CustomOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(Get.parameters['id'] ?? '');
    return Scaffold(
      appBar: AppBar(title: Text('custom_order'.tr)),
      body: GetBuilder<CustomOrderProductsController>(builder: (controller) {
        if (id == null) {
          return Center(child: Text('no_data_found'.tr));
        }
        final item = controller.getById(id);
        if (item == null) {
          // If item not found, ask to refresh the list
          controller.fetchCustomOrders(refresh: true);
          return const Center(child: CircularProgressIndicator());
        }
        final status = item.status;
        final theme = Theme.of(context);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('#${item.id}', style: robotoBold.copyWith(fontSize: 18)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status,
                    style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    )),
              ),
              const Spacer(),
              Text(DateConverter.containTAndZToUTCFormat(item.createdAt ?? ''), style: robotoRegular.copyWith(fontSize: 12, color: Theme.of(context).hintColor)),
            ]),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            if ((item.description ?? '').isNotEmpty)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('description'.tr, style: robotoMedium),
                const SizedBox(height: 6),
                Text(item.description!),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ]),

            if ((item.imageFullUrl ?? '').isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Image.network(
                  item.imageFullUrl!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(children: [
              Text('${'quoted_price'.tr}: ', style: robotoMedium),
              Text(item.quotePrice == null ? 'N/A' : PriceConverter.convertPrice(item.quotePrice), style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
              const Spacer(),
              if (item.orderId != null)
                Text('${'order_id'.tr}: ${item.orderId}', style: robotoMedium),
            ]),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            if ((item.contactName ?? '').isNotEmpty || (item.contactNumber ?? '').isNotEmpty || (item.contactEmail ?? '').isNotEmpty)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('contact_person_name'.tr, style: robotoMedium),
                Text(item.contactName ?? ''),
                const SizedBox(height: 8),
                Text('contact_person_number'.tr, style: robotoMedium),
                Text(item.contactNumber ?? ''),
                const SizedBox(height: 8),
                Text('email'.tr, style: robotoMedium),
                Text(item.contactEmail ?? ''),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ]),

            // Actions moved to sticky bottom bar for better UX.

            if (status == 'converted' && item.orderId != null)
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Get.toNamed(RouteHelper.getOrderDetailsRoute(item.orderId, fromGuestTrack: false));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text('view_order'.tr),
                    ],
                  ),
                ),
              ),
          ]),
        );
      }),
      bottomNavigationBar: GetBuilder<CustomOrderProductsController>(builder: (controller) {
        final theme = Theme.of(context);
        final id = int.tryParse(Get.parameters['id'] ?? '');
        if (id == null) return const SizedBox.shrink();
        final item = controller.getById(id);
        if (item == null) return const SizedBox.shrink();
        final status = item.status;
        if (status != 'quoted') return const SizedBox.shrink();

        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              Dimensions.paddingSizeDefault,
              Dimensions.paddingSizeSmall,
              Dimensions.paddingSizeDefault,
              Dimensions.paddingSizeSmall,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: theme.dividerColor.withOpacity(0.3), width: 0.5),
              ),
            ),
            child: Row(children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    final res = await controller.acceptQuote(item.id);
                    if (res.isSuccess) {
                      Get.offAllNamed(RouteHelper.getCustomOrderListRoute());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('accept'.tr, style: robotoMedium.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error, width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ).copyWith(
                    overlayColor: WidgetStateProperty.all(theme.colorScheme.error.withOpacity(0.08)),
                  ),
                  onPressed: () async {
                    final res = await controller.rejectQuote(item.id);
                    if (res.isSuccess) {
                      Get.offAllNamed(RouteHelper.getCustomOrderListRoute());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close_rounded, size: 18, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Text('reject'.tr, style: robotoMedium.copyWith(color: theme.colorScheme.error)),
                    ],
                  ),
                ),
              )
            ]),
          ),
        );
      }),
    );
  }
}
