import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';

class CustomOrderProductsRepository {
  final ApiClient apiClient;
  CustomOrderProductsRepository({required this.apiClient});

  Future<Response> createCustomOrder({
    String? description,
    XFile? image,
    String? guestId,
    String? contactName,
    String? contactNumber,
    String? contactEmail,
  }) async {
    final Map<String, String> fields = {};
    if (description != null && description.trim().isNotEmpty) {
      fields['description'] = description.trim();
    }
    if (guestId != null && guestId.isNotEmpty) {
      fields['guest_id'] = guestId;
    }
    if (contactName != null && contactName.trim().isNotEmpty) {
      fields['contact_person_name'] = contactName.trim();
    }
    if (contactNumber != null && contactNumber.trim().isNotEmpty) {
      fields['contact_person_number'] = contactNumber.trim();
    }
    if (contactEmail != null && contactEmail.trim().isNotEmpty) {
      fields['contact_person_email'] = contactEmail.trim();
    }

    final multipart = <MultipartBody>[];
    if (image != null) {
      multipart.add(MultipartBody('image', image));
    }
    return await apiClient.postMultipartData(
      AppConstants.customOrderCreateUri,
      fields,
      multipart,
      [],
      handleError: false,
    );
  }

  Future<Response> getCustomOrders({String? guestId, int page = 1}) async {
    final String uri = guestId != null && guestId.isNotEmpty
        ? '${AppConstants.customOrderListUri}?guest_id=$guestId&page=$page'
        : '${AppConstants.customOrderListUri}?page=$page';
    return await apiClient.getData(uri);
  }

  Future<Response> acceptQuote(int id) async {
    final uri = '${AppConstants.customOrderAcceptQuoteUri}?id=$id';
    return await apiClient.postData(uri, {});
  }

  Future<Response> rejectQuote(int id) async {
    final uri = '${AppConstants.customOrderRejectQuoteUri}?id=$id';
    return await apiClient.postData(uri, {});
  }
}
