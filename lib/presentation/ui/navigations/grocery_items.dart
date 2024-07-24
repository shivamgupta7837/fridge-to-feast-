import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/bloc/grocery_items/grocery_items_bloc.dart';
import 'package:fridge_to_feast/models/grocery_items_model.dart';
import 'package:fridge_to_feast/repositary/firebase%20database/grocery_list_firestore.dart';
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
  final _quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<GroceryItemsBloc>().add(ReadGroceryItemsEvent());
  }

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
                  if (state is GroceryItemsLoadedState &&
                      state.listOfItems.isNotEmpty) {
                    return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: state.listOfItems.length,
                        itemBuilder: (context, index) {
                          String? itemName = state.listOfItems[index].itemName;
                          String? expiryDate =
                              state.listOfItems[index].expiryDate;
                          int? quantity = state.listOfItems[index].quantity;
                          int? id = state.listOfItems[index].groceryId;

                          return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$itemName',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    " Quantity: ${quantity.toString()} kg",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              subtitle: Text(
                                'Exp. Date: $expiryDate',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
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
                                                        state: state);
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
                                                                id: id!));
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
                              ));
                        });
                  } else if (state is GroceryItemsLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is GroceryItemsErrorState) {
                    return Text(state.message);
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset("assets/animations/empty_list.json",
                              height: 130),
                          Text(
                            "List is Empty",
                            style: GoogleFonts.alexandria(
                                color: const Color.fromARGB(255, 166, 66, 184),
                                fontWeight: FontWeight.w400),
                          ),
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
              onPressed: () async {
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
      dynamic state}) {
    if (state is GroceryItemsLoadedState) {}
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
                      _itemTextField(isEdittable),
                      const SizedBox(
                        height: 10,
                      ),
                      _quantityTextField(isEdittable),
                      const SizedBox(
                        height: 10,
                      ),
                      _expiryDateTextField(isEdittable, context),
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
                        expiryDate: _expiryDateController.text,
                        id: DateTime.now().millisecondsSinceEpoch,
                        quantity: int.parse(_quantityController.text)));
                    _expiryDateController.clear();
                    _itemsController.clear();
                    _quantityController.clear();
                    Navigator.of(context).pop();
                  } else {
                    context.read<GroceryItemsBloc>().add(
                        UpdateGroceryItemsEvent(
                            updateitem: _itemsController.text,
                            index: index,
                            updateExpiryDate: _expiryDateController.text,
                            id: DateTime.now().millisecondsSinceEpoch,
                            quantity: int.parse(_quantityController.text)));
                    _expiryDateController.clear();
                    _itemsController.clear();
                    _quantityController.clear();
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

  TextFormField _itemTextField(bool isEdittable) {
    return TextFormField(
      autocorrect: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please add Product name ";
        }
        return null;
      },
      controller: _itemsController,
      decoration: InputDecoration(
          label: isEdittable == false
              ? const Text("Add Items")
              : const Text("Update Items"),
          hintText: isEdittable == false ? "Ex: Tomatoes, Bread, Suger" : "",
          hintStyle: TextStyle(color: Colors.grey[400])),
    );
  }

  TextFormField _quantityTextField(bool isEdittable) {
    return TextFormField(
      autocorrect: true,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please add  Quantity ";
        }
      },
      controller: _quantityController,
      decoration: InputDecoration(
          label: isEdittable == false
              ? const Text("Add Quantity")
              : const Text("Update Quantity"),
          hintText: isEdittable == false ? "1 kg" : "",
          hintStyle: TextStyle(color: Colors.grey[400])),
    );
  }

  TextFormField _expiryDateTextField(bool isEdittable, BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Please add expiry date of product ";
        } else if (value == "null") {
          return "Expiry date of product can't be null ";
        }
        return null;
      },
      controller: _expiryDateController,
      decoration: InputDecoration(
          label: isEdittable == false
              ? const Text("Add expiry date")
              : const Text("Update expiry date"),
          hintText: isEdittable == false ? "Ex: 02/12/2024" : "",
          isDense: true,
          hintStyle: TextStyle(color: Colors.grey[400])),
      readOnly: true,
      onTap: () async {
        DateTime? date = await showDatePicker(
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
          context: context,
        );
        _expiryDateController.text = date.toString().split(" ")[0];
      },
    );
  }
}
