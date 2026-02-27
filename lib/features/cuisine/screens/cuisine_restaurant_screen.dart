import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import '../../../common/widgets/custom_asset_image_widget.dart';
import '../widgets/cuisine_filter_widget.dart';

class CuisineRestaurantScreen extends StatefulWidget {
  final int cuisineId;
  final String? name;
  const CuisineRestaurantScreen({super.key, required this.cuisineId, required this.name});

  @override
  State<CuisineRestaurantScreen> createState() => _CuisineRestaurantScreenState();
}

class _CuisineRestaurantScreenState extends State<CuisineRestaurantScreen> {
  final ScrollController _scrollController = ScrollController();
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    Get.find<CuisineController>().initialize();
    Get.find<CuisineController>().getCuisineRestaurantList(widget.cuisineId, 1, false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBarWidget(
        title: '${widget.name!} ${'cuisine'.tr}',
        actions: [
          IconButton(
            onPressed: (){
              Get.toNamed(RouteHelper.getSearchCuisineRestaurantsRoute(widget.cuisineId));
              },
            icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryColor),
          ),

          InkWell(
            onTap: () =>Get.toNamed(RouteHelper.getCartRoute()),
            child: CartWidget(color: Theme.of(context).primaryColor, size: 20, imageIcon: Images.cartIcon),
          ),
          SizedBox(width: Dimensions.paddingSizeDefault),

          CuisineFilterWidget(cuisineId: widget.cuisineId),
          SizedBox(width: Dimensions.paddingSizeDefault),
        ],
      ),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          if(!ResponsiveHelper.isDesktop(context))
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall),
              child: Text('restaurant_list'.tr, style: robotoBold),
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: FooterViewWidget(
                child: Center(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: GetBuilder<CuisineController>(builder: (cuisineController) {
                      final restaurants = cuisineController.cuisineRestaurantsModel?.restaurants;

                      if (cuisineController.isLoading) {
                        return Center(child: Padding(padding: EdgeInsets.all(Dimensions.paddingSizeExtraLarge), child: CircularProgressIndicator()));
                      }

                      if (cuisineController.cuisineRestaurantsModel != null && (restaurants == null || restaurants.isEmpty)) {
                        return Padding(
                          padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            const SizedBox(height: 150),
                            const CustomAssetImageWidget(Images.emptyRestaurant, height: 80, width: 80),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                            Text('there_is_no_restaurant'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
                          ]),
                        );
                      }

                      return PaginatedListViewWidget(
                        scrollController: _scrollController,
                        totalSize: cuisineController.cuisineRestaurantsModel?.totalSize,
                        offset: cuisineController.cuisineRestaurantsModel != null ? int.parse(cuisineController.cuisineRestaurantsModel!.offset!) : null,
                        onPaginate: (int? offset) async {
                          await cuisineController.getCuisineRestaurantList(widget.cuisineId, offset!, false);
                        },
                        productView: ProductViewWidget(
                          isRestaurant: true,
                          products: null,
                          restaurants: restaurants,
                          padding: EdgeInsets.only(
                            left: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                            right: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                            top: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
                            bottom: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
