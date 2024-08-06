import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/cubit/my_recipe/my_recipe_cubit.dart';
import 'package:fridge_to_feast/models/kitchen_campanion_model.dart';
import 'package:google_fonts/google_fonts.dart';

class SaveRecipe extends StatelessWidget {
  final Chat geminiResponse;
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SaveRecipe({super.key, required this.geminiResponse});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<MyRecipeCubit, MyRecipeState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  enableFeedback: true,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text("Add recipes's title"),
                              content: Form(
                                key: _formKey,
                                child: TextFormField(
                                  autocorrect: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please add Title for your recipe. ";
                                    }
                                    return null;
                                  },
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      label: const Text("Add Title"),
                                      hintText: "Ex: How to make cake",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context
                                            .read<MyRecipeCubit>()
                                            .addRecipes(
                                                recipe: geminiResponse.message
                                                    .toString(),
                                                title: _titleController.text,
                                                date: DateTime.now().toString(),
                                                id: DateTime.now()
                                                    .microsecondsSinceEpoch);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor:
                                              Colors.deepPurple.shade300,
                                          content: Text(
                                            "Your recipe is added !!",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ));
                                      }
                                    },
                                    child: Text("Save")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                              ],
                            ));
                  },
                  icon: const Icon(Icons.download_for_offline,
                      color: Colors.deepPurple, size: 24),
                  tooltip: "Add to my recipe",
                )
              ],
            );
          },
        )
      ],
    );
  }
}
