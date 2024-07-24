class UserModel{
  final String name;
  final String email;
  final String profileUrl;

  UserModel({required this.name, required this.email, required this.profileUrl});

    factory UserModel.fromJson(Map<String, dynamic> json){ 
        return UserModel(
            name: json["name"],
            email: json["email"],
            profileUrl: json["user_image"]
        );
    }
}