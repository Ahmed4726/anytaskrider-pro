import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/widgets/cuisine_filter_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/search/controllers/search_controller.dart' as search;
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CuisineRestaurantSearchScreen extends StatefulWidget {
  final int cuisineId;
  const CuisineRestaurantSearchScreen({super.key, required this.cuisineId});

  @override
  State<CuisineRestaurantSearchScreen> createState() => _CuisineRestaurantSearchScreenState();
}

class _CuisineRestaurantSearchScreenState extends State<CuisineRestaurantSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CuisineController>().initSearchData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(builder: (cuisineController) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if(cuisineController.isSearching && !didPop){
            _searchController.text = '';
            cuisineController.changeSearchStatus();
            cuisineController.initSearchData();
          }else if(_searchController.text.isNotEmpty){
            _searchController.text = '';
            setState(() {});
          }else if(!didPop){
            Future.delayed(const Duration(milliseconds: 0), () => Get.back());
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(Dimensions.webMaxWidth, 80),
            child: Container(
              height: 80 + context.mediaQueryPadding.top, width: Dimensions.webMaxWidth,
              padding: EdgeInsets.only(top: context.mediaQueryPadding.top),
              color: Theme.of(context).cardColor,
              alignment: Alignment.center,
              child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                child: Row(children: [

                  IconButton(
                    onPressed: () {
                      if(cuisineController.isSearching){
                        _searchController.text = '';
                        cuisineController.changeSearchStatus();
                        cuisineController.initSearchData();
                      }else if(_searchController.text.isNotEmpty){
                        _searchController.text = '';
                        setState(() {});
                      }else {
                        Get.back();
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),

                  Expanded(child: TextField(
                      controller: _searchController,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                      textInputAction: TextInputAction.search,
                      cursorColor: Theme.of(context).primaryColor,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'search_restaurants_in_cuisine'.tr,
                        hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.3), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.3), width: 1),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(cuisineController.isSearching ? Icons.clear : CupertinoIcons.search, size: 25),
                          onPressed: () {
                            if(cuisineController.isSearching) {
                              _searchController.text = '';
                              cuisineController.changeSearchStatus();
                              cuisineController.initSearchData();
                              // cuisineController.searchCuisineRestaurantList(widget.cuisineId, 1, true, name: _searchController.text.trim());

                            } else {
                              cuisineController.saveSearchHistory(_searchController.text.trim());
                              cuisineController.searchCuisineRestaurantList(widget.cuisineId, 1, true, name: _searchController.text.trim());
                            }

                          },
                        ),
                      ),
                      onSubmitted: (text) {
                        cuisineController.saveSearchHistory(_searchController.text.trim());
                        cuisineController.searchCuisineRestaurantList(widget.cuisineId, 1, true, name: _searchController.text.trim());
                      }
                  )),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  // CuisineFilterWidget(cuisineId: widget.cuisineId),

                ]),
              )),
            ),
          ),
          endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,

          body: SingleChildScrollView(
            controller: _scrollController,
            padding: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Center(
              child: SizedBox(width: Dimensions.webMaxWidth, child: !cuisineController.isSearching ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    cuisineController.historyList.isNotEmpty ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('recent_search'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                      InkWell(
                        onTap: () => cuisineController.clearSearchAddress(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 4),
                          child: Text('clear_all'.tr, style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error,
                          )),
                        ),
                      ),
                    ]) : const SizedBox(),

                    SizedBox(height: cuisineController.historyList.isNotEmpty ? Dimensions.paddingSizeExtraSmall : 0),
                    Wrap(
                      children: cuisineController.historyList.map((historyData) {
                        return Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              InkWell(
                                onTap: () {
                                  _searchController.text = historyData;
                                  cuisineController.saveSearchHistory(historyData);
                                  cuisineController.searchCuisineRestaurantList(widget.cuisineId, 1, true, name: _searchController.text.trim());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                    historyData,
                                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5)),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              InkWell(
                                onTap: () => cuisineController.removeHistory(cuisineController.historyList.indexOf(historyData)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 20),
                                ),
                              )
                            ]),
                          ),
                        );
                      }).toList(),
                    ),

                  ]) : PaginatedListViewWidget(
                  scrollController: _scrollController,
                  totalSize: cuisineController.searchCuisineRestaurantsModel?.totalSize,
                  offset: cuisineController.searchCuisineRestaurantsModel != null ? int.parse(cuisineController.searchCuisineRestaurantsModel!.offset!) : null,
                  onPaginate: (int? offset) async {
                    await cuisineController.searchCuisineRestaurantList(widget.cuisineId, offset!, false, name: cuisineController.searchText);
                  },
                  productView: ProductViewWidget(
                      isRestaurant: true,
                      products: null,
                      restaurants: cuisineController.searchCuisineRestaurantsModel?.restaurants,
                      padding: EdgeInsets.only(
                        left: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                        right: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                        top: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
                        bottom: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                      ),
                  ),
              ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

