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
        onDidReceiveNotificationResponse: (detail) {});
  }

  Future<void> simpleNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            autoCancel: false,
            ticker: 'ticker');

    try {
      // print("Simple notification");
      List<Item> data = await getExpiryDate();
      for (var i = 0; i < data.length; i++) {
        const NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);
        await _flutter_local_notifications.show(
            i,
            "${data[i].itemName.toString()} is Expiring today!",
            "Check out recipe ideas to use it up on Kitchen Companion!!",
            notificationDetails,
            payload: "payload");
      }
    } catch (e) {
      print("error from simple notifications $e");
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


