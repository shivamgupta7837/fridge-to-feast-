import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/kitchen_campanion/kitchen_campanion_cubit.dart';
import 'package:fridge_to_feast/models/kitchen_campanion_model.dart';

class KitchenCompanion extends StatelessWidget {
  KitchenCompanion({
    super.key,
    required this.theme,
  });

  final ThemeData theme;
  final _formKey = GlobalKey<FormState>();
  final _promptController = TextEditingController();

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
                          return _geminiResponse(prompt);
                        }
                        return _userQuery(prompt);
                      },
                    ),
                  ),
                );
              } else if (state is KitchenCampanionEmptyState) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const Center(
                            child:
                                Text("Type some thing to begin the chat !!"))));
              } else if (state is KitchenCampanionLoadingState) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ));
              } else {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child:
                        const Center(child: Text("some thing went wrong !!")));
              }
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _promptController,
                decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(),
                    label: const Text("Ask to AI"),
                    hintText: "How to make cake ?",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        context.read<KitchenCampanionCubit>().sendmessage(
                            message: _promptController.text,
                            promt: true,
                            date: DateTime.now());
                        context.read<KitchenCampanionCubit>().geminiResponse(
                            messageToGemini: _promptController.text);
                        _promptController.clear();
                      },
                    )),
              ),
            ),
          )
        ],
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
          boxShadow: [ BoxShadow(
        color: Colors.black.withOpacity(0.15),
        spreadRadius: 0,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),],
          color: Colors.deepPurple.shade200,
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

  Align _geminiResponse(KitchenCampanionModel prompt) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          boxShadow: [ BoxShadow(
        color: Colors.black.withOpacity(0.15),
        spreadRadius: 0,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),],
          // sha
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: prompt.isPrompt == false
            ? Text(
                prompt.message.toString(),
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: Colors.black),
              )
            : Container(),
      ),
    );
  }
}
