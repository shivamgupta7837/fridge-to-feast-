import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/my_recipe/my_recipe_cubit.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/myDrawer/my_recipe_full_Screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({super.key});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {

  @override
  void initState() {
     context.read<MyRecipeCubit>().getRecipiesFromDataBase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
         centerTitle: true,
     backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 0.5,
        foregroundColor: Colors.black,
        title: Text(
          "My Recipies",
          style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w400,
                      ),
        ),
        ),
        body: BlocBuilder<MyRecipeCubit, MyRecipeState>(
          builder: (context, state) {
           if(state is MyRecipeLoadedState){
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: state.recipesList.length,
                itemBuilder: (context, index) {
                final title = state.recipesList[index].title;
                final recipe = state.recipesList[index].recipe;
                  return ListTile(
                      leading: CircleAvatar(radius: 15,child: Text((index+1).toString(),style: const TextStyle(fontSize: 14),),),
                      title: Text(title.toString()),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete), onPressed: () {
                            context.read<MyRecipeCubit>().deleteRecipes(state.recipesList[index].id,state.recipesList[index]);
                          }),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (_)=>MyRecipeFullScreen(myRecipe: recipe,title:title)));
                          },
                          );
                },
              ),
            );
           }
           else if(state is MyRecipeErrorState){
            return Center(
              child: Text(state.message.toString()),
            );
           }
           else if(state is MyRecipeLoadingState){
            return const Center(
              child: CircularProgressIndicator()
            );
           }
           else{
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Image.asset("assets/icons/recipe.png",height: 40,),
                  SizedBox(height: 20,),
                  Text("No Recpies",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 15),),
                ],
              )
            );
           }
          },
        ));
  }
}
