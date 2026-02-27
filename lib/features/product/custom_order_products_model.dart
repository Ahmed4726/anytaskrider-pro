import 'package:image_picker/image_picker.dart';

class CustomOrderRequestModel {
  final String? description;
  final XFile? image;

  CustomOrderRequestModel({this.description, this.image});

  Map<String, String> toFields({String? guestId}) {
    final map = <String, String>{};
    if (description != null && description!.trim().isNotEmpty) {
      map['description'] = description!.trim();
    }
    if (guestId != null && guestId.isNotEmpty) {
      map['guest_id'] = guestId;
    }
    return map;
  }
}

