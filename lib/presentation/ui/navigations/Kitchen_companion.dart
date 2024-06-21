import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/kitchen_campanion/kitchen_campanion_cubit.dart';
import 'package:fridge_to_feast/logic/cubit/my_recipe/my_recipe_cubit.dart';
import 'package:fridge_to_feast/models/kitchen_campanion_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class KitchenCompanion extends StatefulWidget {
  KitchenCompanion({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  State<KitchenCompanion> createState() => _KitchenCompanionState();
}

class _KitchenCompanionState extends State<KitchenCompanion> {
  final _promptController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _userPrompt = "";

  final myFocusNode = FocusNode();


   @override
  void initState() {
    super.initState();
    // Request focus when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocBuilder<KitchenCampanionCubit, KitchenCampanionState>(
                  builder: (context, state) {
                    if (state is KitchenCampanionLoadedState) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: ListView.builder(
                            reverse: true,
                            itemCount: state.user.length,
                            itemBuilder: (BuildContext context, int index) {
                              final newList = state.user.reversed.toList();
                              final prompt = newList[index];
                              if (prompt.isPrompt == false) {
                                return _geminiResponse(
                                    prompt, context, _promptController,state);
                              }
                              return _userQuery(prompt);
                            },
                          ),
                        ),
                      );
                    } else if (state is KitchenCampanionEmptyState) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child:  Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset("assets/animations/chat-bot.json",height: 120),
                                  SizedBox(height: 10,),
                                  Text("Type some thing to begin the chat !!",style: GoogleFonts.alexandria(fontSize: 13,fontWeight: FontWeight.w500,color: const Color.fromARGB(255, 166, 66, 184)),),
                                ],
                              )));
                    } 
                    else if (state is KitchenCampanionErrorState) {
                      return SizedBox(
                             height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Text(state.message),
                        ),
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

// user will use this text box for ask the query.
  Widget _userInput(BuildContext context) {
    return  Column(
      children: [
        Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(15),
            child: TextFormField(
              focusNode: myFocusNode,
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
                label: const Text(
                  "Type to ask your kitchen companion",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                hintText: "Ex: How to make a cake?",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<KitchenCampanionCubit>().sendmessage(
                          message: _promptController.text,
                          promt: true,
                          date: DateTime.now());
                      context.read<KitchenCampanionCubit>().getGeminiResponse(
                          messageToGemini: _promptController.text);
                      _promptController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

// Questions asked from ai will display in this method.
  Align _userQuery(KitchenCampanionModel prompt) {
    return  Align(
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
        // If ispropmt is true it means user query will be shown other vice gemini respone will be shown.
        child: prompt.isPrompt == true
            ? Text(
                prompt.message.toString(),
                style: widget.theme.textTheme.bodyLarge!
                    .copyWith(color: widget.theme.colorScheme.onPrimary),
              )
            : Container(),
      ),
    );
  }

// respone genrated by gemini will display by this method.
  Align _geminiResponse(KitchenCampanionModel prompt, BuildContext context,
      TextEditingController userPrompt,dynamic state) {
    return  Align(
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
                    style: widget.theme.textTheme.bodyLarge!
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




