class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'phone': phoneNumber,
        'address': address,
      };

  UserModel.empty()
      : id = '',
        name = '',
        email = '',
        phoneNumber = '',
        address = '';
}
