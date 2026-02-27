import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/product/custom_order_products_repository.dart';

class CustomOrderProductsController extends GetxController implements GetxService {
  final CustomOrderProductsRepository repository;
  CustomOrderProductsController({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    _pickedImage = null;
    _isLoading = false;



  }

  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 85);
      if (image != null) {
        _pickedImage = image;
        update();
      }
    } catch (e) {
      showCustomSnackBar('failed'.tr);
    }
  }

  void clearImage() {
    _pickedImage = null;
    update();
  }

  Future<ResponseModel> submit({String? description, String? contactName, String? contactNumber, String? contactEmail}) async {
    if ((description == null || description.trim().isEmpty) && _pickedImage == null) {
      showCustomSnackBar('Please provide a description or image');
      return ResponseModel(false, 'validation_failed');
    }

    _isLoading = true;
    update();

    String? guestId;
    try {
      final auth = Get.find<AuthController>();
      if (auth.isGuestLoggedIn()) {
        guestId = auth.getGuestId();
        // persist guest number if provided
        if ((contactNumber ?? '').isNotEmpty) {
          await auth.saveGuestNumber(contactNumber!);
        }
      }
    } catch (_) {}

    final response = await repository.createCustomOrder(
      description: description?.trim(),
      image: _pickedImage,
      guestId: guestId,
      contactName: contactName,
      contactNumber: contactNumber,
      contactEmail: contactEmail,
    );

    ResponseModel responseModel;
    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar('request_sent_successfully'.tr, isError: false);
      responseModel = ResponseModel(true, 'success');
      _pickedImage = null;
    } else {
      String message = 'failed_to_submit_request';
      try {
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
      } catch (_) {}
      showCustomSnackBar(message);
      responseModel = ResponseModel(false, message);
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  // List handling
  bool _isListLoading = false;
  bool get isListLoading => _isListLoading;

  List<CustomOrderItem> _orders = [];
  List<CustomOrderItem> get orders => _orders;

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _currentPage < _lastPage;

  Future<void> fetchCustomOrders({bool refresh = true, int page = 1}) async {
    if (refresh) {
      _orders = [];
      _currentPage = 1;
      _lastPage = 1;
    }
    if (page == 1) {
      _isListLoading = true;
    } else {
      _isFetchingMore = true;
    }
    update();

    String? guestId;
    try {
      final auth = Get.find<AuthController>();
      if (auth.isGuestLoggedIn()) {
        guestId = auth.getGuestId();
      }
    } catch (_) {}

    final response = await repository.getCustomOrders(guestId: guestId, page: page);
    if (response.statusCode == 200) {
      try {
        final parsed = CustomOrderListResponse.fromJson(response.body);
        _currentPage = parsed.currentPage ?? 1;
        _lastPage = parsed.lastPage ?? 1;
        final newItems = parsed.data ?? [];
        if (page == 1) {
          _orders = newItems;
        } else {
          _orders = [..._orders, ...newItems];
        }
      } catch (_) {}
      update();
    }

    _isListLoading = false;
    _isFetchingMore = false;
    update();
  }

  Future<void> loadNextPage() async {
    if (hasMore && !_isFetchingMore) {
      final next = _currentPage + 1;
      await fetchCustomOrders(refresh: false, page: next);
    }
  }

  CustomOrderItem? getById(int id) {
    try {
      return _orders.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel> acceptQuote(int id) async {
    _isLoading = true; update();
    final res = await repository.acceptQuote(id);
    _isLoading = false; update();
    if (res.statusCode == 200) {
      showCustomSnackBar('accepted'.tr, isError: false);
      return ResponseModel(true, 'success');
    }
    showCustomSnackBar('failed'.tr);
    return ResponseModel(false, 'failed');
  }

  Future<ResponseModel> rejectQuote(int id) async {
    _isLoading = true; update();
    final res = await repository.rejectQuote(id);
    _isLoading = false; update();
    if (res.statusCode == 200) {
      showCustomSnackBar('rejected'.tr, isError: false);
      return ResponseModel(true, 'success');
    }
    showCustomSnackBar('failed'.tr);
    return ResponseModel(false, 'failed');
  }
}

class CustomOrderListResponse {
  final int? currentPage;
  final List<CustomOrderItem>? data;
  final int? lastPage;
  final int? total;

  CustomOrderListResponse({this.currentPage, this.data, this.lastPage, this.total});

  factory CustomOrderListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? items = json['data'];
    return CustomOrderListResponse(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      total: json['total'],
      data: items != null ? items.map((e) => CustomOrderItem.fromJson(e)).toList() : [],
    );
  }
}

class CustomOrderItem {
  final int id;
  final String status;
  final String? description;
  final double? quotePrice;
  final int? orderId;
  final String? createdAt;
  final String? imageFullUrl;
  final String? contactName;
  final String? contactNumber;
  final String? contactEmail;

  CustomOrderItem({
    required this.id,
    required this.status,
    this.description,
    this.quotePrice,
    this.orderId,
    this.createdAt,
    this.imageFullUrl,
    this.contactName,
    this.contactNumber,
    this.contactEmail,
  });

  factory CustomOrderItem.fromJson(Map<String, dynamic> json) {
    return CustomOrderItem(
      id: json['id'],
      status: json['status'] ?? '',
      description: json['description'],
      quotePrice: json['quote_price'] == null ? null : (json['quote_price'] as num).toDouble(),
      orderId: json['order_id'],
      createdAt: json['created_at'],
      imageFullUrl: json['image_full_url'],
      contactName: json['contact_person_name'],
      contactNumber: json['contact_person_number'],
      contactEmail: json['contact_person_email'],
    );
  }
}
