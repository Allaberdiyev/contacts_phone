class ContactsModel {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String imageUrl;

  ContactsModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }

  factory ContactsModel.fromJson(Map<String, dynamic> json, String id) {
    return ContactsModel(
      id: id,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
