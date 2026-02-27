import 'dart:async';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/search/domain/models/search_suggestion_model.dart';
import 'package:stackfood_multivendor/features/search/domain/services/search_service_interface.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class SearchController extends GetxController implements GetxService {
  final SearchServiceInterface searchServiceInterface;

  SearchController({required this.searchServiceInterface}) {
    // create speech instance for reuse
    _speech = stt.SpeechToText();
  }

  List<Product>? _searchProductList;
  List<Product>? get searchProductList => _searchProductList;

  List<Product>? _suggestedFoodList;
  List<Product>? get suggestedFoodList => _suggestedFoodList;

  SearchSuggestionModel? _searchSuggestionModel;
  SearchSuggestionModel? get searchSuggestionModel => _searchSuggestionModel;

  List<Restaurant>? _searchRestList;
  List<Restaurant>? get searchRestList => _searchRestList;

  List<Restaurant>? _allRestList;

  String _searchText = '';
  String get searchText => _searchText;

  double _lowerValue = 0;
  double get lowerValue => _lowerValue;

  double _upperValue = 0;
  double get upperValue => _upperValue;

  List<String> _historyList = [];
  List<String> get historyList => _historyList;

  bool _isSearchMode = true;
  bool get isSearchMode => _isSearchMode;

  final List<String> _sortList = ['ascending'.tr, 'descending'.tr, 'price_low_to_high'.tr, 'price_high_to_low'.tr];
  List<String> get sortList => _sortList;

  final List<String> _restaurantSortList = ['ascending'.tr, 'descending'.tr];
  List<String> get restaurantSortList => _restaurantSortList;

  int _sortIndex = -1;
  int get sortIndex => _sortIndex;

  int _restaurantSortIndex = -1;
  int get restaurantSortIndex => _restaurantSortIndex;

  int _rating = -1;
  int get rating => _rating;

  int _restaurantRating = -1;
  int get restaurantRating => _restaurantRating;

  bool _isRestaurant = false;
  bool get isRestaurant => _isRestaurant;

  bool _isAvailableFoods = false;
  bool get isAvailableFoods => _isAvailableFoods;

  bool _isAvailableRestaurant = false;
  bool get isAvailableRestaurant => _isAvailableRestaurant;

  bool _isNewArrivalsFoods = false;
  bool get isNewArrivalsFoods => _isNewArrivalsFoods;

  bool _isNewArrivalsRestaurant = false;
  bool get isNewArrivalsRestaurant => _isNewArrivalsRestaurant;

  bool _isPopularFood = false;
  bool get isPopularFood => _isPopularFood;

  bool _isPopularRestaurant = false;
  bool get isPopularRestaurant => _isPopularRestaurant;

  bool _isDiscountedFoods = false;
  bool get isDiscountedFoods => _isDiscountedFoods;

  bool _isDiscountedRestaurant = false;
  bool get isDiscountedRestaurant => _isDiscountedRestaurant;

  bool _veg = false;
  bool get veg => _veg;

  bool _restaurantVeg = false;
  bool get restaurantVeg => _restaurantVeg;

  bool _nonVeg = false;
  bool get nonVeg => _nonVeg;

  bool _restaurantNonVeg = false;
  bool get restaurantNonVeg => _restaurantNonVeg;

  int? totalSize;
  int? pageOffset;
  bool _paginate = false;
  bool get paginate => _paginate;

  final List<int> _selectedCuisines = [];
  List<int> get selectedCuisines => _selectedCuisines;

  bool _isOpenRestaurant = false;
  bool get isOpenRestaurant => _isOpenRestaurant;


  void selectCuisine(int cuisineId) {
    if(_selectedCuisines.contains(cuisineId)) {
      _selectedCuisines.removeAt(_selectedCuisines.indexOf(cuisineId));
    } else {
      _selectedCuisines.add(cuisineId);
    }
    update();
  }

  void toggleVeg() {
    _veg = !_veg;
    update();
  }

  void toggleResVeg() {
    _restaurantVeg = !_restaurantVeg;
    update();
  }

  void toggleNonVeg() {
    _nonVeg = !_nonVeg;
    update();
  }

  void toggleResNonVeg() {
    _restaurantNonVeg = !_restaurantNonVeg;
    update();
  }

  void toggleAvailableFoods() {
    _isAvailableFoods = !_isAvailableFoods;
    update();
  }

  void toggleAvailableRestaurant() {
    _isAvailableRestaurant = !_isAvailableRestaurant;
    update();
  }

  void toggleNewArrivalFoods() {
    _isNewArrivalsFoods = !_isNewArrivalsFoods;
    update();
  }

  void toggleNewArrivalRestaurant() {
    _isNewArrivalsRestaurant = !_isNewArrivalsRestaurant;
    update();
  }

  void togglePopularFoods() {
    _isPopularFood = !_isPopularFood;
    update();
  }

  void togglePopularRestaurant() {
    _isPopularRestaurant = !_isPopularRestaurant;
    update();
  }

  void toggleOpenRestaurant() {
    _isOpenRestaurant = !_isOpenRestaurant;
    update();
  }

  void toggleDiscountedFoods() {
    _isDiscountedFoods = !_isDiscountedFoods;
    update();
  }

  void toggleDiscountedRestaurant() {
    _isDiscountedRestaurant = !_isDiscountedRestaurant;
    update();
  }

  void setRestaurant(bool isRestaurant, {bool willUpdate = true}) {
    _isRestaurant = isRestaurant;
    if(willUpdate) {
      update();
    }
  }

  void setSearchMode(bool isSearchMode, {bool canUpdate = true}) {
    _isSearchMode = isSearchMode;
    if(isSearchMode) {
      _searchText = '';
      _allRestList = null;
      _searchProductList = null;
      _searchRestList = null;
      _sortIndex = -1;
      _restaurantSortIndex = -1;
      _isDiscountedFoods = false;
      _isDiscountedRestaurant = false;
      _isAvailableFoods = false;
      _isAvailableRestaurant = false;
      _veg = false;
      _restaurantVeg = false;
      _nonVeg = false;
      _restaurantNonVeg = false;
      _rating = -1;
      _restaurantRating = -1;
      _upperValue = 0;
      _lowerValue = 0;
    }
    if (_isRestaurant){
      _isRestaurant = !_isRestaurant;
    }
    if(canUpdate) {
      update();
    }
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    update();
  }

  void setSearchText(String text) {
    _searchText = text;
    update();
  }

  void getSuggestedFoods() async {
    _suggestedFoodList = null;
    _suggestedFoodList = await searchServiceInterface.getSuggestedFoods();
    update();
  }

  Future<List<String>> getSearchSuggestions(String searchText) async {
    List<String> foods = <String>[];
    _searchSuggestionModel = await searchServiceInterface.getSearchSuggestions(searchText);
    if(_searchSuggestionModel != null) {
      for (var food in _searchSuggestionModel!.foods!) {
        foods.add(food.name!);
      }
      for (var restaurant in _searchSuggestionModel!.restaurants!) {
        foods.add(restaurant.name!);
      }
    }
    return foods;
  }

  Future<void> searchData(String query, int offset, {bool willUpdate = true}) async {

    int rating = searchServiceInterface.findRatings(_isRestaurant ? _restaurantRating : _rating);
    bool isNewActive = _isRestaurant ? _isNewArrivalsRestaurant : _isNewArrivalsFoods;
    bool isPopular = _isRestaurant ? _isPopularRestaurant : _isPopularFood;
    String type = searchServiceInterface.processType(_isRestaurant, _restaurantVeg, _restaurantNonVeg, _veg, _nonVeg);
    bool discounted = _isRestaurant ? _isDiscountedRestaurant : _isDiscountedFoods;
    String sortBy = searchServiceInterface.getSortBy(_isRestaurant, _restaurantSortIndex, _sortIndex);

      _searchText = query;
      if(offset == 1) {
        if (_isRestaurant) {
          _searchRestList = null;
          _allRestList = null;
        } else {
          _searchProductList = null;
        }
      } else {
        _paginate = true;
      }
      if (!_historyList.contains(query)) {
        _historyList.insert(0, query);
      }
      searchServiceInterface.saveSearchHistory(_historyList);
      _isSearchMode = false;
      if(willUpdate) {
        update();
      }

      Response response = await searchServiceInterface.getSearchData(
        query: query,
        isRestaurant: _isRestaurant,
        offset: offset,
        type: type,
        isNew: isNewActive ? 1 : 0,
        isPopular: isPopular ? 1 : 0,
        isOneRatting: rating == 1 ? 1 : 0,
        isTwoRatting: rating == 2 ? 1 : 0,
        isThreeRatting: rating == 3 ? 1 : 0,
        isFourRatting: rating == 4 ? 1 : 0,
        isFiveRatting: rating == 5 ? 1 : 0,
        sortBy: sortBy,
        discounted: discounted ? 1 : 0,
        minPrice: _lowerValue, maxPrice: _upperValue,
        selectedCuisines: _selectedCuisines,
        isOpenRestaurant: _isOpenRestaurant ? 1 : 0,
      );

      if (response.statusCode == 200) {
        if (query.isEmpty) {
          if (_isRestaurant) {
            _searchRestList = [];
          } else {
            _searchProductList = [];
          }
        } else {

          if (_isRestaurant) {
            if(offset == 1) {
              _searchRestList = [];
              _allRestList = [];
            }
            _searchRestList!.addAll(RestaurantModel.fromJson(response.body).restaurants!);
            _allRestList!.addAll(RestaurantModel.fromJson(response.body).restaurants!);
            totalSize = RestaurantModel.fromJson(response.body).totalSize;
            pageOffset = RestaurantModel.fromJson(response.body).offset;
          } else {
            if(offset == 1) {
              _searchProductList = [];
            }
            _searchProductList!.addAll(ProductModel.fromJson(response.body).products!);
            totalSize = ProductModel.fromJson(response.body).totalSize;
            pageOffset = ProductModel.fromJson(response.body).offset;
            if(_lowerValue == 0 || _upperValue == 0) {
              _lowerValue = ProductModel.fromJson(response.body).minPrice ?? 0;
              _upperValue = ProductModel.fromJson(response.body).maxPrice ?? 0;
            }
          }
        }
      }
    _paginate = false;
    update();
  }

  void getHistoryList() {
    _searchText = '';
    _historyList = [];
    _searchProductList = [];
    _allRestList = [];
    _searchRestList = [];
    _historyList.addAll(searchServiceInterface.getSearchHistory());
  }

  void removeHistory(int index) {
    _historyList.removeAt(index);
    searchServiceInterface.saveSearchHistory(_historyList);
    update();
  }

  void clearSearchAddress() async {
    searchServiceInterface.clearSearchHistory();
    _historyList = [];
    update();
  }

  void setRating(int rate) {
    _rating = rate;
    update();
  }

  void setRestaurantRating(int rate) {
    _restaurantRating = rate;
    update();
  }

  void setSortIndex(int index) {
    _sortIndex = index;
    update();
  }

  void setRestSortIndex(int index) {
    _restaurantSortIndex = index;
    update();
  }

  void resetFilter() {
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;
    _isAvailableFoods = false;
    _isDiscountedFoods = false;
    _veg = false;
    _nonVeg = false;
    _sortIndex = -1;
    _isNewArrivalsFoods = false;
    _isPopularFood = false;
    update();
  }

  void resetRestaurantFilter() {
    _restaurantRating = -1;
    _isAvailableRestaurant = false;
    _isDiscountedRestaurant = false;
    _restaurantVeg = false;
    _restaurantNonVeg = false;
    _restaurantSortIndex = -1;
    _isNewArrivalsRestaurant = false;
    _isPopularRestaurant = false;
    _isOpenRestaurant = false;
    update();
  }

  void saveSearchHistory(String query) {
    if (!_historyList.contains(query)) {
      _historyList.insert(0, query);
    }
    searchServiceInterface.saveSearchHistory(_historyList);
  }


  ///Voice Search..................

  bool voiceIsListening = false;
  String voiceText = '';
  double voiceSoundLevel = 0.0;
  bool voiceAvailable = false;
  Timer? _voiceAutoSubmitTimer;

  late stt.SpeechToText _speech;

  /// Initialize speech (safe to call multiple times)
  Future<void> initVoice({bool isUpdate = true}) async {
    try {
      final available = await _speech.initialize(onStatus: _onStatus, onError: _onError);
      voiceAvailable = available;
    } catch (e) {
      voiceAvailable = false;
    }
    if(isUpdate) update();
  }

  void _onStatus(String status) {
    if (status == stt.SpeechToText.listeningStatus) {
      setVoiceListening(true);
      cancelVoiceAutoSubmit();
    } else if (status == stt.SpeechToText.doneStatus || status == stt.SpeechToText.notListeningStatus || status == 'not listening') {
      setVoiceListening(false);
      scheduleVoiceAutoSubmit(const Duration(seconds: 2));
    }
  }

  void _onError(dynamic error) {
    setVoiceListening(false);
  }

  /// Start listening and optionally update an external TextEditingController live
  Future<void> startVoiceListening({TextEditingController? externalController}) async {
    cancelVoiceAutoSubmit();

    // clear any previous session
    try {
      if (_speech.isListening) await _speech.stop();
      await _speech.cancel();
    } catch (_) {}

    if (!voiceAvailable) {
      await initVoice();
      if (!voiceAvailable) return;
    }

    // reset
    setVoiceText('');
    setVoiceSoundLevel(0.0);

    try {
      await _speech.listen(
        onResult: (result) {
          final recognized = result.recognizedWords;
          setVoiceText(recognized);
          if (externalController != null) {
            externalController.text = recognized;
            externalController.selection = TextSelection.fromPosition(TextPosition(offset: externalController.text.length));
          }
        },
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 5),
        onSoundLevelChange: (level) {
          final normalized = (level / 50).clamp(0.0, 1.0);
          setVoiceSoundLevel(normalized);
        },
        localeId: Get.deviceLocale?.languageCode,
        listenOptions: stt.SpeechListenOptions(partialResults: true, cancelOnError: true, listenMode: stt.ListenMode.search),
      );
      if (_speech.isListening) {
        setVoiceListening(true);
      } else {
        setVoiceListening(false);
      }
    } catch (e) {
      setVoiceListening(false);
    }
  }

  /// Stop or cancel listening
  Future<void> stopVoiceListening({bool submit = false}) async {
    cancelVoiceAutoSubmit();
    try {
      await _speech.stop();
    } catch (e) {
      try {
        await _speech.cancel();
      } catch (_) {}
    }
    setVoiceListening(false);
    if (submit) await submitVoiceNow();
  }

  void setVoiceListening(bool value, {bool isUpdate = true}) {
    voiceIsListening = value;
    if(isUpdate) update();
  }

  void setVoiceText(String text, {bool isUpdate = true}) {
    voiceText = text;
    if(isUpdate) update();
  }

  void setVoiceSoundLevel(double level, {bool isUpdate = true}) {
    voiceSoundLevel = level;
    if(isUpdate) update();
  }

  void scheduleVoiceAutoSubmit(Duration duration) {
    _voiceAutoSubmitTimer?.cancel();
    _voiceAutoSubmitTimer = Timer(duration, () async {
      await submitVoiceNow();
    });
  }

  void cancelVoiceAutoSubmit() {
    _voiceAutoSubmitTimer?.cancel();
    _voiceAutoSubmitTimer = null;
  }

  Future<void> submitVoiceNow() async {
    cancelVoiceAutoSubmit();
    final text = voiceText.trim();
    if (text.isNotEmpty) {
      try {
        if ((Get.isBottomSheetOpen ?? false) || (Get.isDialogOpen ?? false)) {
          Get.back();
        }
      } catch (_) {}
      await searchData(text, 1);
    }
  }

  @override
  void onClose() {
    _voiceAutoSubmitTimer?.cancel();
    super.onClose();
  }

}