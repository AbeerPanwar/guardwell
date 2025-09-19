import '../../domain/entities/tourist.dart';

class TouristModel extends Tourist {
  TouristModel({
    required super.fullName,
    required super.dob,
    required super.itinerary,
    required super.passport,
    required super.aadhaar,
  });

  Map<String, dynamic> toJson() {
    return {
      "kyc": {
        "fullName": fullName,
        "dob": dob,
      },
      "itinerary": itinerary,
      "passport": passport,
      "aadhaar": aadhaar,
    };
  }
}
