import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/firebase_options.dart';
import 'package:fridge_to_feast/logic/bloc/grocery_items/grocery_items_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/auth/auth_cubit.dart';
import 'package:fridge_to_feast/logic/cubit/kitchen_campanion/kitchen_campanion_cubit.dart';
import 'package:fridge_to_feast/logic/cubit/my_recipe/my_recipe_cubit.dart';
import 'package:fridge_to_feast/logic/cubit/youtube_player/youtube_player_cubit.dart';
import 'package:fridge_to_feast/mytest.dart';
import 'package:fridge_to_feast/presentation/ui/features/app_goto_screen.dart';
import 'package:fridge_to_feast/presentation/ui/splash_screen.dart';
import 'package:fridge_to_feast/services/push%20notification/push_notification.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notification = Notifications();

  Workmanager()
      .executeTask((String task, Map<String, dynamic>? inputData) async {
    try {
      await notification.showExpiryNotification();
      return Future.value(true);
    } catch (e) {
      print("Error in callbackDispatcher: $e");
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
    await Notifications.init();

    // WorkManager initialization
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    int id = DateTime.now().microsecondsSinceEpoch;
    Workmanager().registerPeriodicTask(
      id.toString(),
      'simplePeriodicTask',
      frequency: Duration(hours: 3),
    );
  } catch (e) {
    print("Error from main function: $e");
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroceryItemsBloc>(
          create: (context) => GroceryItemsBloc(),
        ),
        BlocProvider<KitchenCampanionCubit>(
          create: (context) => KitchenCampanionCubit(),
        ),
        BlocProvider<YoutubeCubit>(
          create: (context) => YoutubeCubit(),
        ),
        BlocProvider<MyRecipeCubit>(
          create: (context) => MyRecipeCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(103, 58, 183, 1)),
            useMaterial3: true,
          ),
          // home:  AppGoToScreen(),
          home: SplashScreen(),
          // home: TestFeature()),
    ));
  }
}
