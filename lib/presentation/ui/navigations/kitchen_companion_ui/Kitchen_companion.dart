import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/kitchen_campanion/kitchen_campanion_cubit.dart';
import 'package:fridge_to_feast/models/kitchen_campanion_model.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/kitchen_companion_ui/save_recipies_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class KitchenCompanion extends StatefulWidget {
  const KitchenCompanion({
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

  @override
  void initState() {
    super.initState();

    context.read<KitchenCampanionCubit>().getDataFromDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      itemCount: state.listOfChats.length,
                      itemBuilder: (BuildContext context, int index) {
                        final newList = state.listOfChats.reversed.toList();
                        final data = newList[index];


                        if (data.sender == "bot") {
                          return _geminiResponse(
                              data, context, _promptController, state);
                        }
                        return _userQuery(data);
                      },
                    ),
                  ),
                );
              } else if (state is KitchenCampanionEmptyState) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/animations/chat-bot.json",
                            height: 120),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Type some thing to begin the chat !!",
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 166, 66, 184)),
                        ),
                      ],
                    )));
              } else if (state is KitchenCampanionErrorState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          _userInput(context)
        ],
      ),
    );
  }

  Form _userInput(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
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
            label:  Text(
              "Type to ask your kitchen companion",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w300,fontSize: 
              14),
            ),
            hintText: "Ex: How to make a cake?",
            hintStyle: TextStyle(color: Colors.grey.shade500),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<KitchenCampanionCubit>().sendmessage(
                      message: _promptController.text,
                      promt: "user",
                      date: DateTime.now());

                  context.read<KitchenCampanionCubit>().getGeminiResponse(
                      messageToGemini: _promptController.text,
                      promt: "bot",
                      date: DateTime.now().toString(),
                      typingStatus: true,

                      );
              
                  _promptController.clear();

                 

                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _geminiResponse(Chat gemData, BuildContext context,
      TextEditingController userPrompt, dynamic state) {
    return   Align(
      alignment: Alignment.topLeft,
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
            gemData.sender == "bot"
                ? Text(
                    gemData.message.toString(),
                    style: widget.theme.textTheme.bodyLarge!
                        .copyWith(color: Colors.black),
                     
                  )
                : Container(),
            gemData.sender == "bot"
                ? SaveRecipe(geminiResponse: gemData)
                : Container()
          ],
        ),
      )
    );
  }

  Align _userQuery(Chat userData) {
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
        // If ispropmt is "user" it means user query will be shown other vice gemini respone will be shown.
        child: userData.sender == "user"
            ? Text(
                userData.message.toString(),
                style: widget.theme.textTheme.bodyLarge!
                    .copyWith(color: widget.theme.colorScheme.onPrimary,),
              )
            : Container(),
      ),
    );
  }
}
