// class KitchenCampanionModel {
//   final String message;
//   final bool isPrompt;
//   final DateTime date;

//   KitchenCampanionModel({required this.message, required this.isPrompt, required this.date});
// }

class KitchenCampanionModel {
  List<Chat>? chat;

  KitchenCampanionModel({this.chat});

  KitchenCampanionModel.fromJson(Map<String, dynamic> json) {
    if (json['chat'] != null) {
      chat = <Chat>[];
      json['chat'].forEach((v) {
        chat!.add( Chat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.chat != null) {
      data['chat'] = chat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chat {
  String? timestamp;
  String? sender;
  String? message;

  Chat({required this.timestamp, required this.sender, required this.message});

  Chat.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    sender = json['sender'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['sender'] = this.sender;
    data['message'] = this.message;
    return data;
  }
}



/*
{
    "KitchenCampanionModel": [
        {
                "conversationid": 85346532476,
                "date": "23-10-2020",
                "geminiResponse": "response",
                "isPrompt": true,
                "query": "query"
            
        },
        {
                "conversationid": 8345532476,
                "date": "23-10-2020",
                "geminiResponse": "response",
                "isPrompt": true,
                "query": "query"
            
        }
    ]
}

*/