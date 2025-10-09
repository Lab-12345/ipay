class UserModel {
  final String id;
  final String phone;
  final String name;

  UserModel({required this.id, required this.phone, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      name: json['name'],
    );
  }
}
