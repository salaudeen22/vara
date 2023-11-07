class UserModel {
  final String id;
  final String name;
  final String phone;
  final String childEmail;
  final String parentEmail;
  final String type;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.childEmail,
    required this.parentEmail,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'childEmail': childEmail,
      'parentEmail': parentEmail,
      'type':type,
    };
  }

}
