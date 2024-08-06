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


/*
{
  "users": {
    "user1": {
      "userId": "user1",
      "email": "user1@example.com",
      "name": "John Doe",
      "grocery": {
        "lists": [
          {
            "listId": "list1",
            "name": "Weekly Groceries",
            "items": [
              {"itemId": "item1", "name": "Apples", "quantity": 5},
              {"itemId": "item2", "name": "Milk", "quantity": 2}
            ]
          },
          {
            "listId": "list2",
            "name": "Party Supplies",
            "items": [
              {"itemId": "item3", "name": "Chips", "quantity": 3},
              {"itemId": "item4", "name": "Soda", "quantity": 4}
            ]
          }
        ]
      },
      "kitchen campanion": {
        "conversation1": {
          "conversationId": "conversation1",
          "startTime": "2024-06-21T10:00:00Z",
          "messages": [
            {
              "messageId": "message1",
              "sender": "user",
              "timestamp": "2024-06-21T10:01:00Z",
              "content": "Hi, I need help with my grocery list."
            },
            {
              "messageId": "message2",
              "sender": "ai",
              "timestamp": "2024-06-21T10:01:05Z",
              "content": "Sure, what do you need assistance with?"
            }
          ]
        },
        
       
        "recipe": [
          {"id":recipe id,
          "name":"how to make cake",
          "description":"lorem ipsum dolor sit amet, consectetur"
          }
        ]
        
      }
      }
    },
    "user2": {
      "userId": "user2",
      "email": "user2@example.com",
      "name": "Jane Smith",
      "grocery": {
        "lists": [
          {
            "listId": "list3",
            "name": "Vegetables",
            "items": [
              {"itemId": "item5", "name": "Carrots", "quantity": 10},
              {"itemId": "item6", "name": "Broccoli", "quantity": 3}
            ]
          }
        ]
      },
      "kitchen campanion": {
        "conversation2": {
          "conversationId": "conversation2",
          "startTime": "2024-06-20T15:00:00Z",
          "messages": [
            {
              "messageId": "message3",
              "sender": "user",
              "timestamp": "2024-06-20T15:01:00Z",
              "content": "Can you add broccoli to my vegetable list?"
            },
            {
              "messageId": "message4",
              "sender": "ai",
              "timestamp": "2024-06-20T15:01:10Z",
              "content": "Broccoli has been added to your vegetable list."
            }
          ]
        }

        "Saved recipies":{
        recipe: [
          {"id":recipe id,
          "name":"how to make cake",
          "description":"lorem ipsum dolor sit amet, consectetur"
          }
        ]
        }
      }
    }
  }
}


*/