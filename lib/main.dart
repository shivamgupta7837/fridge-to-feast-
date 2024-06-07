import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/firebase_options.dart';
import 'package:fridge_to_feast/logic/bloc/grocery_items/grocery_items_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/kitchen_campanion/kitchen_campanion_cubit.dart';
import 'package:fridge_to_feast/logic/cubit/youtube_player/youtube_player_cubit.dart';
import 'package:fridge_to_feast/presentation/screens/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePageScreen()
    ),
    );
  }
}
