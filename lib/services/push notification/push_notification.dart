import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/keys/firebase_collections_keys.dart';
import 'package:fridge_to_feast/models/grocery_items_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications {
  static final FlutterLocalNotificationsPlugin _flutter_local_notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        linux: null);
    await _flutter_local_notifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (detail) => null);
  }

  Future<void> simpleNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    try {
      print("Simple notification");
      List<Item> data = await getExpiryDate();
      for (var i = 0; i < data.length; i++) {
        const NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);
        print(data[i].itemName);
        await _flutter_local_notifications.show(
            i,
            "Alert",
            "${data[i].itemName.toString()} is going to expire!!",
            notificationDetails,
            payload: "payload");
      }
    } catch (e) {
      print("from simple notifications $e");
    }
  }

  Future<List<Item>> getExpiryDate() async {
    final CollectionReference groceriesObj =
        FirebaseFirestore.instance.collection("users");
    List<Item> groceryListFromDatabase = [];
    List<Item> items = [];
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);

    final currentDate =
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();

    try {
      final document = groceriesObj.doc(uId).collection(
          FirebaseCollectionsKeys.groceryItemsCollectionId.toString());
      DocumentSnapshot<Map<String, dynamic>> dataSnapShot = await document
          .doc(FirebaseCollectionsKeys.groceryItemsDocumentId)
          .get();
      List data = await dataSnapShot.data()!["items"];
      if (data.isEmpty) {
        return [];
      } else {
        for (var ele in data) {
          groceryListFromDatabase.add(Item.fromJson(ele));
        }

        items = groceryListFromDatabase
            .where((date) => date.expiryDate == currentDate)
            .toList();
      }
      return items;
    } catch (e) {
      throw Exception(e);
    }
  }
}




/*




/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/keys/firebase_collections_keys.dart';
import 'package:fridge_to_feast/models/grocery_items_model.dart';
import 'package:fridge_to_feast/repositary/firebase%20database/grocery_list_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications {
  static final FlutterLocalNotificationsPlugin _flutter_local_notifications =
      FlutterLocalNotificationsPlugin();
  final CollectionReference _groceriesObj =
      FirebaseFirestore.instance.collection("users");

  static Future<void> init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //! Thiis is will be a drawable resource.
    // final DarwinInitializationSettings initializationSettingsDarwin =
    //     DarwinInitializationSettings(
    //         onDidReceiveLocalNotification: (id, title, body, payload) => null);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null, // Add this {initializationSettingsDarwin} instead of {null} while making ipa ready for IOS devices.
        linux: null);
    _flutter_local_notifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (detail) => null);
  }

  void simpleNotification({required String name,required String body}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

      _flutter_local_notifications
        .show(0, "Hurry Up", "$name is going to Expiry !!", notificationDetails, payload: "payload");

 
  }

  Future<void> getExpiryDate() async {
    List<Item> groceryListFromDatabase = [];
    List<Item> items = [];
    groceryListFromDatabase.clear();
    items.clear();
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    final uId = sharePref.getString(AuthKeys.USER_ID);

    final currentDate =
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();

    try {
      final document = _groceriesObj.doc(uId).collection(
          FirebaseCollectionsKeys.groceryItemsCollectionId.toString());
      DocumentSnapshot<Map<String, dynamic>> dataSnapShot = await document
          .doc(FirebaseCollectionsKeys.groceryItemsDocumentId)
          .get();
      List data = await dataSnapShot.data()!["items"];
      if (data.isNotEmpty)  {
        for (var ele in data) {
          groceryListFromDatabase.add(Item.fromJson(ele));
        }

        items = groceryListFromDatabase
            .where((date) => date.expiryDate == currentDate)
            .toList();
      }


      for(int i=0;i<items.length;i++) {
        simpleNotification(body: items[i].itemName.toString(), name: items[i].expiryDate.toString(),);
      }
      
    } catch (e) {
      throw Exception(e);
    }
  }
}




*/



*/