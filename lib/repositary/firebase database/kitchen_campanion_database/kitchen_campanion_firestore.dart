import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/keys/firebase_collections_keys.dart';
import 'package:fridge_to_feast/models/kitchen_campanion_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class KitchenCampanionFirestore extends Equatable {
  final CollectionReference _fireBaseObj =
      FirebaseFirestore.instance.collection("users");
  List<dynamic> _chatList = [];
  final List<Chat> _getChats = [];

  void saveChatsToDataBase({required Chat chats}) async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);
    final document = _fireBaseObj.doc(uId).collection(
        FirebaseCollectionsKeys.kitchenCampanionCollectionId.toString());

    try {
      DocumentSnapshot<Map<String, dynamic>> isDocExists = await document
          .doc(FirebaseCollectionsKeys.kitchenCampanionDocumentnId)
          .get();

      if (isDocExists.exists) {
        _chatList = isDocExists.data()!["kitchenCampanion"];
        _chatList.add(chats.toJson());
        await document
            .doc(FirebaseCollectionsKeys.kitchenCampanionDocumentnId)
            .set({"kitchenCampanion": _chatList});
      } else {
        await document
            .doc(FirebaseCollectionsKeys.kitchenCampanionDocumentnId)
            .set({
          "kitchenCampanion": [chats.toJson()]
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Chat>> getChatsFromDataBase() async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);
    List data = [];
    try {
      final document = _fireBaseObj.doc(uId).collection(
          FirebaseCollectionsKeys.kitchenCampanionCollectionId.toString());

      DocumentSnapshot<Map<String, dynamic>> dataSnapShot = await document
          .doc(FirebaseCollectionsKeys.kitchenCampanionDocumentnId)
          .get();
      if (dataSnapShot.data() != null) {
        data = await dataSnapShot.data()!["kitchenCampanion"];
      }

      if (data.isEmpty) {
        return [];
      } else {
        for (var ele in data) {
          _getChats.add(Chat.fromJson(ele));
        }
        // print(newList.runtimeType);
      }
      return _getChats;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  List<Object?> get props => [_getChats, _chatList, _fireBaseObj];
}
