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
import 'package:fridge_to_feast/presentation/ui/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen()
    ),
    );
  }
 }
