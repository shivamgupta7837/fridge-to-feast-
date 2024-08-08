import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/keys/firebase_collections_keys.dart';
import 'package:fridge_to_feast/models/grocery_items_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroceryListFireStore extends Equatable {
  final CollectionReference _groceriesObj =
      FirebaseFirestore.instance.collection("users");
  List<dynamic> _groceryListToAddItems = [];
  final List<Item> _groceryListToGetItems = [];

  void saveGroceryToDataBase({required Item items}) async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);
    final document = _groceriesObj.doc(uId).collection(
        FirebaseCollectionsKeys.groceryItemsCollectionId.toString());

    try {
      DocumentSnapshot<Map<String, dynamic>> isDocExists = await document
          .doc(FirebaseCollectionsKeys.groceryItemsDocumentId)
          .get();

      if (isDocExists.exists) {
        _groceryListToAddItems = isDocExists.data()!["items"];
          _groceryListToAddItems.add(items.toJson());
          await document
              .doc(FirebaseCollectionsKeys.groceryItemsDocumentId)
              .set({"items": _groceryListToAddItems});
      } else {
        await document.doc(FirebaseCollectionsKeys.groceryItemsDocumentId).set({
          "items": [items.toJson()]
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Item>> getDataFromDataBase() async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);

    try {
      final document = _groceriesObj.doc(uId).collection(
          FirebaseCollectionsKeys.groceryItemsCollectionId.toString());

      DocumentSnapshot<Map<String, dynamic>> dataSnapShot = await document
          .doc(FirebaseCollectionsKeys.groceryItemsDocumentId)
          .get();
      List data = await dataSnapShot.data()!["items"];

      if (data.isEmpty) {
        return [];
      } else {
        for (var ele in data) {
          _groceryListToGetItems.add(Item.fromJson(ele));
        }
        // print(newList.runtimeType);
      }
      return _groceryListToGetItems;
    } catch (e) {
      throw Exception(e);
    }
  }

  void deleteDataFromDataBase({required Item item }) async {
    // List<Item> list = [];
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);
    final document = _groceriesObj.doc(uId).collection(
        FirebaseCollectionsKeys.groceryItemsCollectionId.toString());

    try {
      document.doc(FirebaseCollectionsKeys.groceryItemsDocumentId).update({"items":FieldValue.arrayRemove([item.toJson()])});
    } catch (e) {
      print(e);
    }
  }

  void updateDataFromDataBase({required Item item , required id,required index}) async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);
    final document = _groceriesObj.doc(uId).collection(
        FirebaseCollectionsKeys.groceryItemsCollectionId.toString());

    try {
      DocumentSnapshot<Map<String, dynamic>> dataBaseList = await document
          .doc(FirebaseCollectionsKeys.groceryItemsDocumentId)
          .get();

        // print("DataBaseList $dataBaseList");
        List list = dataBaseList.data()!["items"];
           list.removeWhere((item) => item["grocery_id"] == id);
        list.insert(index, item.toJson());

        // print("updated list $list");
          await document
              .doc(FirebaseCollectionsKeys.groceryItemsDocumentId)
              .set({"items": list});

    } catch (e) {
      print(e);
    }
  }

  @override
  List<Object?> get props =>
      [_groceryListToGetItems, _groceryListToAddItems, _groceriesObj];
}
