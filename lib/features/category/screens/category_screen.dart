import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<CategoryController>().clearSearch(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Get.find<CategoryController>().clearSearch();
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: 'categories'.tr,
          onBackPressed: (){
            Get.find<CategoryController>().clearSearch();
            Get.back();
          },
        ),
        endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
        body: GetBuilder<CategoryController>(builder: (catController) {
          return SafeArea(
            child: SingleChildScrollView(
              controller: scrollController, child: FooterViewWidget(
                child: Column(children: [

                  ResponsiveHelper.isDesktop(context) ? Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                    height: 64, width: Dimensions.webMaxWidth,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('categories'.tr, style: robotoSemiBold),

                        SizedBox(
                          height: 35, width: 250,
                          child: SearchBar(
                            controller: _searchController,
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).cardColor),
                            elevation: WidgetStatePropertyAll(0),
                            side: WidgetStatePropertyAll(BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.15))),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            overlayColor: WidgetStateColor.transparent,
                            onChanged: (value) {
                              catController.getCategoryList(true, search: value);
                            },
                            onSubmitted: (value) {
                              catController.getCategoryList(true, search: value);
                            },
                            hintText: 'search_by_category'.tr,
                            hintStyle: WidgetStatePropertyAll(
                              robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                            ),
                            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
                            leading: Icon(CupertinoIcons.search, size: 16, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                            trailing: _searchController.text.isEmpty ? [const SizedBox()] : _searchController.text.isNotEmpty ? [InkWell(
                              child: Icon(Icons.clear, size: 16, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                              onTap: () {
                                _searchController.clear();
                                catController.clearSearch();
                                catController.update();
                              },
                            )] : [const SizedBox()],
                          ),
                        ),
                      ],
                    ),
                  ) : const SizedBox(),

                  ResponsiveHelper.isDesktop(context) ? SizedBox() : Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                    child: SizedBox(
                      height: 47,
                      child: SearchBar(
                        controller: _searchController,
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).cardColor),
                        elevation: WidgetStatePropertyAll(0),
                        side: WidgetStatePropertyAll(BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.15))),
                        onChanged: (value) {
                          catController.getCategoryList(true, search: value);
                        },
                        onSubmitted: (value) {
                          catController.getCategoryList(true, search: value);
                        },
                        hintText: 'search_by_category'.tr,
                        hintStyle: WidgetStatePropertyAll(
                          robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                        ),
                        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
                        leading: Icon(CupertinoIcons.search, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                        trailing: _searchController.text.isEmpty ? [const SizedBox()] : _searchController.text.isNotEmpty ? [InkWell(
                          child: Icon(Icons.clear, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                          onTap: () {
                            _searchController.clear();
                            catController.clearSearch();
                            catController.update();
                          },
                        )] : [const SizedBox()],
                      ),
                    ),
                  ),

                  Center(child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: catController.categoryList != null ? catController.categoryList!.isNotEmpty ? GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 7 : ResponsiveHelper.isTab(context) ? 4 : 3,
                        childAspectRatio: (1/1),
                        mainAxisSpacing: Dimensions.paddingSizeSmall,
                        crossAxisSpacing: Dimensions.paddingSizeSmall,
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      itemCount: catController.categoryList!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                          ),
                          child: CustomInkWellWidget(
                            onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                              catController.categoryList![index].id, catController.categoryList![index].name!,
                            )),
                            radius: Dimensions.radiusDefault,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImageWidget(
                                  height: 50, width: 50, fit: BoxFit.cover,
                                  image: '${catController.categoryList![index].imageFullUrl}',
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text(
                                catController.categoryList![index].name!, textAlign: TextAlign.center,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                              ),

                            ]),
                          ),
                        );
                      },
                    ) : NoDataScreen(title: 'no_category_found'.tr) : const Center(child: CircularProgressIndicator()),
                  )),
                ],
              )),
            ),
          );
        }),
      ),
    );
  }
}
