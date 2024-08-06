
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/keys/firebase_collections_keys.dart';
import 'package:fridge_to_feast/models/my_recipies_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MyRecipesFirestore extends Equatable {
  final CollectionReference _fireBaseObj =
      FirebaseFirestore.instance.collection("users");
  List<dynamic> _recipiesList = [];
  final List<MyRecipiesModel> _getRecipies = [];

  void saveChatsToDataBase({required MyRecipiesModel recipies}) async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);
    final document = _fireBaseObj.doc(uId).collection(
        FirebaseCollectionsKeys.kitchenCampanionCollectionId.toString());

    try {
      DocumentSnapshot<Map<String, dynamic>> isDocExists = await document
          .doc(FirebaseCollectionsKeys.saveRecipesDocumentnId)
          .get();

      if (isDocExists.exists) {
        _recipiesList = isDocExists.data()!["savedRecipies"];
          _recipiesList.add(recipies.toJson());
          await document
              .doc(FirebaseCollectionsKeys.saveRecipesDocumentnId)
              .set({"savedRecipies": _recipiesList});
      } else {
        await document.doc(FirebaseCollectionsKeys.saveRecipesDocumentnId).set({
          "savedRecipies": [recipies.toJson()]
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MyRecipiesModel>> getChatsFromDataBase() async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);
    try {
      final document = _fireBaseObj.doc(uId).collection(
          FirebaseCollectionsKeys.kitchenCampanionCollectionId.toString());

      DocumentSnapshot<Map<String, dynamic>> dataSnapShot = await document
          .doc(FirebaseCollectionsKeys.saveRecipesDocumentnId)
          .get();
      List data = await dataSnapShot.data()!["savedRecipies"];

      if (data.isEmpty) {
        return [];
      } else {
        for (var ele in data) {
          _getRecipies.add(MyRecipiesModel.fromJson(ele));
        }
        // print(newList.runtimeType);
      }
      return _getRecipies;
    } catch (e) {
      throw Exception(e);
    }
  }



  void deleteDataFromDataBase({required MyRecipiesModel item }) async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);
    final document = _fireBaseObj.doc(uId).collection(
        FirebaseCollectionsKeys.kitchenCampanionCollectionId.toString());

    try {
      document.doc(FirebaseCollectionsKeys.saveRecipesDocumentnId).update({"savedRecipies":FieldValue.arrayRemove([item.toJson()])});
    } catch (e) {
      debugPrintStack();
    }
  }

  @override
  List<Object?> get props =>
      [_recipiesList, _getRecipies, _fireBaseObj];
}
