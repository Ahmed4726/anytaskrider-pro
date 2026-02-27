import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/product/custom_order_products_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class CustomOrderListScreen extends StatefulWidget {
  const CustomOrderListScreen({super.key});

  @override
  State<CustomOrderListScreen> createState() => _CustomOrderListScreenState();
}

class _CustomOrderListScreenState extends State<CustomOrderListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CustomOrderProductsController>().fetchCustomOrders();
    _scrollController.addListener(() {
      final ctrl = Get.find<CustomOrderProductsController>();
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ctrl.loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color _statusColor(String status, BuildContext context) {
    switch (status) {
      case 'quoted':
        return Colors.orange;
      case 'converted':
        return Theme.of(context).primaryColor;
      case 'pending':
        return Colors.blueGrey;
      default:
        return Theme.of(context).disabledColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('custom_orders'.tr)),
      body: GetBuilder<CustomOrderProductsController>(builder: (controller) {
        if (controller.isListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.orders.isEmpty) {
          return Center(child: Text('no_custom_orders_found'.tr, style: robotoMedium));
        }
        final itemCount = controller.orders.length + (controller.isFetchingMore ? 1 : 0);
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchCustomOrders(refresh: true, page: 1);
          },
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              if (index >= controller.orders.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final item = controller.orders[index];
              return InkWell(
                onTap: () {
                  if (item.orderId != null) {
                    Get.toNamed(RouteHelper.getOrderDetailsRoute(item.orderId, fromGuestTrack: false));
                  } else {
                    Get.toNamed(RouteHelper.getCustomOrderDetailRoute(item.id));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.05), blurRadius: 8, spreadRadius: 1)],
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('#${item.id}', style: robotoBold),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(item.status, context).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(item.status, style: robotoMedium.copyWith(color: _statusColor(item.status, context), fontSize: 12)),
                        ),
                        const Spacer(),
                        Text(DateConverter.containTAndZToUTCFormat(item.createdAt ?? ''), style: robotoRegular.copyWith(fontSize: 12, color: Theme.of(context).hintColor)),
                      ]),
                      const SizedBox(height: 6),
                      if ((item.description ?? '').isNotEmpty)
                        Text(item.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Row(children: [
                        Text('${'quoted_price'.tr}: ', style: robotoMedium),
                        Text(
                          item.quotePrice == null ? 'N/A' : PriceConverter.convertPrice(item.quotePrice),
                          style: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                        ),
                        const Spacer(),
                        if (item.orderId != null)
                          Text('${'order_id'.tr}: ${item.orderId}', style: robotoMedium),
                        const Icon(Icons.chevron_right),
                      ]),
                    ]),
                  ),
                ]),
              ));
            },
          ),
        );
      }),
    );
  }
}
