class AddressModel {
  String addressLine1;
  String addressLine2;
  String street;
  String city;
  String state;
  String country;
  String zipCode;

  AddressModel({
    required this.addressLine1,
    required this.addressLine2,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
  });

  // Convert AddressModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
    };
  }

  // Create AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ?? '',
    );
  }
}
