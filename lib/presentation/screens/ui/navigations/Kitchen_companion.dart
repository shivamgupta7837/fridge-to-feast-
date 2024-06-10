import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/kitchen_campanion/kitchen_campanion_cubit.dart';
import 'package:fridge_to_feast/logic/cubit/my_recipe/my_recipe_cubit.dart';
import 'package:fridge_to_feast/models/kitchen_campanion_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class KitchenCompanion extends StatelessWidget {
  KitchenCompanion({
    super.key,
    required this.theme,
  });

  final ThemeData theme;
  final _promptController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String _userPrompt = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<KitchenCampanionCubit, KitchenCampanionState>(
            builder: (context, state) {
              if (state is KitchenCampanionLoadedState) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.71,
                    child: ListView.builder(
                      reverse: true,
                      itemCount: state.user.length,
                      itemBuilder: (BuildContext context, int index) {
                        final newList = state.user.reversed.toList();
                        final prompt = newList[index];
                        if (prompt.isPrompt == false) {
                          return _geminiResponse(
                              prompt, context, _promptController);
                        }
                        return _userQuery(prompt);
                      },
                    ),
                  ),
                );
              } else if (state is KitchenCampanionEmptyState) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(
                        child: Text("Type some thing to begin the chat !!")));
              } 
              // else if (state is KitchenCampanionLoadingState) {
              //   return Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: SizedBox(
              //       height: MediaQuery.of(context).size.height * 0.7,
              //       child: Row(
              //         children: [
              //           Text(
              //             "Typing",
              //             style: GoogleFonts.poppins(),
              //           ),
              //           Lottie.asset("assets/animations/typing.json",
              //               height: 25),
              //         ],
              //       ),
              //     ),
              //   );
              // } 
              else if (state is KitchenCampanionErrorState) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child:
                        const Center(child: Text("some thing went wrong !!")));
              }
            },
          ),
          _userInput(context),
        ],
      ),
    );
  }

  Widget _userInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Please type something";
          }
          return null;
        },
        controller: _promptController,
        autocorrect: true,
        decoration: InputDecoration(
            isDense: true,
            
            border: const OutlineInputBorder(),
            label: const Text("Type to ask to your kitchen campanion",style: TextStyle(fontWeight: FontWeight.w400),),
            hintText: "Ex: How to make cake ?",
            hintStyle: TextStyle(color: Colors.grey.shade500),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (_promptController.text.isNotEmpty) {
                  context.read<KitchenCampanionCubit>().sendmessage(
                      message: _promptController.text,
                      promt: true,
                      date: DateTime.now());
                  context.read<KitchenCampanionCubit>().geminiResponse(
                      messageToGemini: _promptController.text);
                }else{
                   ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.deepPurple.shade300,
                                    content: Text(
                                      "This field cannot be empty !",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ));
                }
                  _userPrompt = _promptController.text;
                  _promptController.clear();
              },
            )),
      ),
    );
  }

  Align _userQuery(KitchenCampanionModel prompt) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          color: Colors.deepPurple.shade400,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: prompt.isPrompt == true
            ? Text(
                prompt.message.toString(),
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: theme.colorScheme.onPrimary),
              )
            : Container(),
      ),
    );
  }

  Align _geminiResponse(KitchenCampanionModel prompt, BuildContext context,
      TextEditingController userPrompt) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            prompt.isPrompt == false
                ? Text(
                    prompt.message.toString(),
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: Colors.black),
                  )
                : Container(),
            prompt.isPrompt == false
                ? SaveRecipe(prompt: prompt, userPrompt: _userPrompt)
                : Container()
          ],
        ),
      ),
    );
  }
}


class SaveRecipe extends StatelessWidget{

  final KitchenCampanionModel  prompt;
  final String  userPrompt;

  const SaveRecipe({ required this.prompt,required this.userPrompt});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<MyRecipeCubit, MyRecipeState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                              radius: 18,
                              child: IconButton(
                                onPressed: () {
                                  print(userPrompt);
                                  context.read<MyRecipeCubit>().addRecipes(
                                      recipe: prompt.message.toString(),
                                      title: userPrompt);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.deepPurple.shade300,
                                    content: Text(
                                      "Your recipe is added in list, You can find your recipe in my recipe list. !!",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ));
                                },
                                icon: const Icon(Icons.save,
                                    color: Colors.deepPurple, size: 17),
                                tooltip: "Add to my recipe",
                              ))
                        ],
                      );
                    },
                  )
      ],
    );
  }
  
}