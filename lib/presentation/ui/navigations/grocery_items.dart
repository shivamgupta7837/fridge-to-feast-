import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/bloc/grocery_items/grocery_items_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GroceryItems extends StatefulWidget {
  GroceryItems({
    super.key,
  });

  @override
  State<GroceryItems> createState() => _GroceryItemsState();
}

class _GroceryItemsState extends State<GroceryItems> {

  final _itemsController = TextEditingController();
  final _expiryDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

@override

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
     
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.72,
              padding: const EdgeInsets.all(10),
              child: BlocBuilder<GroceryItemsBloc, GroceryItemsState>(
                builder: (context, state) {
                  if (state is GroceryItemsLoadedState && state.listOfItems.isNotEmpty) {
                    final items = state.listOfItems;
                    return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final itemName = state.listOfItems[index]["item"];
                          final expiryDate =
                              state.listOfItems[index]["expiry-date"];
                          return ListTile(
                              leading: const Icon(Icons.shopping_cart),
                              title: Text('$itemName'),
                              subtitle: Text('Expiry Date: $expiryDate'),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              ElevatedButton(
                                                  onPressed: () {
                                                    _showAlertDialogBox(
                                                        context: context,
                                                        isEdittable: true,
                                                        index: index,
                                                        state:state
                                                        );
                                                  },
                                                  child: const Text(
                                                      "Rename Item")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    context
                                                        .read<
                                                            GroceryItemsBloc>()
                                                        .add(
                                                            DeleteGroceryItemsEvent(
                                                                index: index));
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                      "Delete Item")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cancel")),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                              );
                        });
                  }else if(state is GroceryItemsEmptyState){
                    return Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                          "assets/animations/empty_list.json",
                          height: 100
                        ),
                             Text("Add grocery items",style: GoogleFonts.alexandria(color: const Color.fromARGB(255, 166, 66, 184),fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  }
                  else if(state is GroceryItemsErrorState){
                    return Text(state.message);
                  }
                   else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Lottie.asset(
                          "assets/animations/empty_list.json",
                          height: 130
                        ),
                          Text("Add grocery items",style: GoogleFonts.alexandria(color: const Color.fromARGB(255, 166, 66, 184),fontWeight: FontWeight.w400),),
                        ],
                      ),
                    );
                  }
                },
              )),
          addGroceryItemWidget(context),
        ],
      ),
    );
  }

  Padding addGroceryItemWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              tooltip: "Add Grocery",
              onPressed: () {
                _showAlertDialogBox(context: context, isEdittable: false);
              },
              child: Icon(Icons.add))
        ],
      ),
    );
  }

  Future<dynamic> _showAlertDialogBox(
      {required BuildContext context,
      required bool isEdittable,
      int index = 0,
      dynamic state
      }) {
        if(state is GroceryItemsLoadedState){

        }
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isEdittable == false
              ? const Text('Add Grocery')
              : const Text('Update Grocery'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please add Product name ";
                          }
                        },
                        controller: _itemsController,
                        decoration: InputDecoration(
                            label: isEdittable == false
                                ? const Text("Add Items")
                                : const Text("Update Items"),
                            hintText: isEdittable == false
                                ? "Ex: Tomatoes, Bread, Suger"
                                : "",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please add Expiry date of product ";
                          }
                        },
                        controller: _expiryDateController,
                        decoration: InputDecoration(
                            label: isEdittable == false
                                ? const Text("Add expiry date")
                                : const Text("Update expiry date"),
                            hintText:
                                isEdittable == false ? "Ex: 02/12/2024" : "",
                            isDense: true,
                            hintStyle: TextStyle(color: Colors.grey[400])),
                        readOnly: true,
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                            context: context,
                          );
                          _expiryDateController.text =
                              date.toString().split(" ")[0];
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: isEdittable == false
                  ? const Text('Add')
                  : const Text("Update"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (isEdittable == false) {
                    context.read<GroceryItemsBloc>().add(AddGroceryItemsEvent(
                        item: _itemsController.text,
                        expiryDate: _expiryDateController.text));
                    _expiryDateController.clear();
                    _itemsController.clear();
                    Navigator.of(context).pop();
                  } else {
                    context.read<GroceryItemsBloc>().add(
                        UpdateGroceryItemsEvent(
                            updateitem: _itemsController.text,
                            index: index,
                            updateExpiryDate: _expiryDateController.text));
                    _expiryDateController.clear();
                    _itemsController.clear();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
