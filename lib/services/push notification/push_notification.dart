import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fridge_to_feast/keys/auth_keys.dart';
import 'package:fridge_to_feast/keys/firebase_collections_keys.dart';
import 'package:fridge_to_feast/models/grocery_items_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications {
  // Local notifications instance
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) {
      // Handle notification response
    });
  }

  // Display a simple notification with expiry alerts
  Future<void> showExpiryNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'fridge_to_feast_channel_id',
      'Fridge to Feast Notifications',
      channelDescription:
          'Notifications for Fridge to Feast, including recipe suggestions, grocery list reminders, and more.',
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: false,
      ticker: 'ticker',
    );

    try {
      List<Item> expiringItems = await _getExpiringItems();
      await _sendNotifications(expiringItems, androidDetails);
    } catch (e) {
      print("Error from showExpiryNotification: $e");
    }
  }

  // Get the items that are expiring soon or today
  Future<List<Item>> _getExpiringItems() async {
    final CollectionReference groceriesCollection =
        FirebaseFirestore.instance.collection("users");

    List<Item> groceryList = [];
    List<Item> expiringItems = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(AuthKeys.USER_ID);

    final currentDateStr = DateFormat("yyyy-MM-dd").format(DateTime.now());

    try {
      // Fetch grocery items from Firestore
      final document = groceriesCollection
          .doc(userId)
          .collection(FirebaseCollectionsKeys.groceryItemsCollectionId);

      DocumentSnapshot<Map<String, dynamic>> snapshot = await document
          .doc(FirebaseCollectionsKeys.groceryItemsDocumentId)
          .get();

      List<dynamic> itemsData = snapshot.data()?["items"] ?? [];

      if (itemsData.isEmpty) {
        return [];
      }

      // Parse items and check expiry dates
      groceryList = itemsData.map((item) => Item.fromJson(item)).toList();
      DateTime currentDate = DateTime.parse(currentDateStr);

      for (var item in groceryList) {
        DateTime expiryDate = DateTime.parse(item.expiryDate);

        // Check if the item expires today
        if (expiryDate == currentDate) {
          expiringItems.add(item);
        } else {
          // Check if the item is expiring soon (in 4 or 2 days)
          int daysUntilExpiry = expiryDate.difference(currentDate).inDays;
          if (daysUntilExpiry == 4 || daysUntilExpiry == 2) {
            expiringItems.add(item);
          }
        }
      }

      return expiringItems;
    } catch (e) {
      throw Exception("Error fetching expiring items: $e");
    }
  }

  // Helper method to send notifications
  Future<void> _sendNotifications(
      List<Item> items, AndroidNotificationDetails details) async {
    for (var i = 0; i < items.length; i++) {
      Item item = items[i];
      String notificationTitle =
          "${item.itemName} is Expiring on ${item.expiryDate}!";
      String notificationBody =
          "Check out recipe ideas to use it up on Kitchen Companion!";

      await _localNotificationsPlugin.show(
        i, // Unique ID for each notification
        notificationTitle,
        notificationBody,
        NotificationDetails(android: details),
        payload: "payload",
      );
    }
  }
}
