class MyRecipiesModel{
  final String title;
  final String recipe;
  final String date;
  final int id;

  MyRecipiesModel({required this.title, required this.recipe, required this.date, required this.id});

    factory MyRecipiesModel.fromJson(Map<String,dynamic> json){
      return MyRecipiesModel(title: json["title"], recipe: json["recipe"], date: json["date"],id:json["id"]
        
      );
    }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['recipe'] = recipe;
    data['date'] = date;
    data['id'] = id;
    return data;
  }
}

