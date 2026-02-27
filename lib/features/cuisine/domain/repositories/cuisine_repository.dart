import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/api/local_client.dart';
import 'package:stackfood_multivendor/common/enums/data_source_enum.dart';
import 'package:stackfood_multivendor/features/cuisine/domain/models/cuisine_model.dart';
import 'package:stackfood_multivendor/features/cuisine/domain/models/cuisine_restaurants_model.dart';
import 'package:stackfood_multivendor/features/cuisine/domain/repositories/cuisine_repository_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect/connect.dart';

class CuisineRepository implements CuisineRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  CuisineRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future<CuisineModel?> getList({int? offset, DataSourceEnum? source}) async {
    CuisineModel? cuisineModel;
    String cacheId = AppConstants.cuisineUri;

    switch(source!){
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.cuisineUri);
        if(response.statusCode == 200){
          cuisineModel = CuisineModel.fromJson(response.body);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          cuisineModel = CuisineModel.fromJson(jsonDecode(cacheResponseData));
        }
    }

    return cuisineModel;
  }

  @override
  Future<CuisineRestaurantModel?> getRestaurantList(int offset, int cuisineId, {String? name, String? query}) async {
    CuisineRestaurantModel? cuisineRestaurantsModel;
    StringBuffer mainUrl = StringBuffer();
    mainUrl.write('${AppConstants.cuisineRestaurantUri}?cuisine=$cuisineId&offset=$offset&limit=${(name == null || name.isEmpty) ? 10 : 30}');

     if (name != null && name.isNotEmpty) mainUrl.write('&name=$name');
     if (query != null && query.isNotEmpty) mainUrl.write('&filter_data=$query');

     Response response = await apiClient.getData(mainUrl.toString());

    // Response response = await apiClient.getData('${AppConstants.cuisineRestaurantUri}?cuisine_id=$cuisineId&offset=$offset&limit=10');
    if(response.statusCode == 200) {
      cuisineRestaurantsModel = CuisineRestaurantModel.fromJson(response.body);
    }
    return cuisineRestaurantsModel;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveSearchHistory(List<String> searchHistories) async {
    return await sharedPreferences.setStringList(AppConstants.searchCuisineHistory, searchHistories);
  }

  @override
  List<String> getSearchHistory() {
    return sharedPreferences.getStringList(AppConstants.searchCuisineHistory) ?? [];
  }

  @override
  Future<bool> clearSearchHistory() async {
    return sharedPreferences.setStringList(AppConstants.searchCuisineHistory, []);
  }

}