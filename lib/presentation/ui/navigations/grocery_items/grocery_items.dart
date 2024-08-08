import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/bloc/grocery_items/grocery_items_bloc.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/grocery_items/update_grocery_items.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class GroceryItems extends StatefulWidget {
  const GroceryItems({
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
  final List<String> _items = ['Kg', 'Gm', 'Pkt', 'Lt', "Dozen", "Bottle"];

  // Variable to hold the currently selected item
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    context.read<GroceryItemsBloc>().add(ReadGroceryItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<GroceryItemsBloc, GroceryItemsState>(
            builder: (context, state) {
              final currentDate =
                  DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
              if (state is GroceryItemsLoadedState &&
                  state.listOfItems.isNotEmpty) {
                return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: state.listOfItems.length,
                    itemBuilder: (context, index) {
                      String itemName = state.listOfItems[index].itemName;
                      String expiryDate = state.listOfItems[index].expiryDate;
                      int quantity = state.listOfItems[index].quantity;
                      int id = state.listOfItems[index].groceryId;
                      String unit = state.listOfItems[index].units;
                      String status = "";
                      int oldDate = int.parse(expiryDate.split("-").join(""));
                      int todaysDay =
                          int.parse(currentDate.split("-").join(""));

                      if (oldDate == todaysDay) {
                        status = "Expiring today";
                      } else if (oldDate < todaysDay) {
                        status = "Already expired";
                      }
                      return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: status == "Expiring today"
                              ? Colors.amber
                              : status == "Already expired"
                                  ? Color.fromARGB(255, 212, 50, 38)
                                  : null,
                          title: goroceryNameText(itemName, status, quantity,unit),
                          subtitle: expirationStatus(oldDate, todaysDay, expiryDate, status),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: status == "Expiring today"
                                  ? Colors.white
                                  : status == "Already expired"
                                      ? Colors.white
                                      : null,
                            ),
                            onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UpdateGroceryItems(
                                                              expiryDate:
                                                                  expiryDate
                                                                      .toString(),
                                                              id: id!,
                                                              itemName: itemName
                                                                  .toString(),
                                                              index: index,
                                                              quantity:
                                                                  quantity!,
                                                                  units: unit,
                                                            )));
                                              },
                                              child: const Text("Rename Item")),
                                          ElevatedButton(
                                              onPressed: () {
                                                context
                                                    .read<GroceryItemsBloc>()
                                                    .add(DeleteGroceryItemsEvent(
                                                        itemName: state
                                                            .listOfItems[index],
                                                        id: id!));
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Delete Item")),
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
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
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
                  ),
                );
              }
            },
          )),
      floatingActionButton: addGroceryItemWidget(context),
    );
  }

  Text expirationStatus(int oldDate, int todaysDay, String expiryDate, String status) {
    return Text(
                          oldDate > todaysDay
                              ? 'Expiring on: $expiryDate'
                              : oldDate < todaysDay
                                  ? "Already Expired"
                                  : "Expiring today",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: status == "Expiring today" ||
                                      status == "Already expired"
                                  ? Colors.white
                                  : null),
                        );
  }

  Row goroceryNameText(String itemName, String status, int quantity,String unit) {
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              itemName,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: status == "Expiring today" ||
                                          status == "Already expired"
                                      ? Colors.white
                                      : null),
                            ),
                            Text(
                              " Quantity: ${quantity.toString()} $unit",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: status == "Expiring today" ||
                                          status == "Already expired"
                                      ? Colors.white
                                      : null),
                            )
                          ],
                        );
  }

  FloatingActionButton addGroceryItemWidget(BuildContext context) {
    return FloatingActionButton(
        tooltip: "Add Grocery",
        onPressed: () async {
          _showAlertDialogBox(context: context);
        },
        child: Icon(Icons.add));
  }

  Future<dynamic> _showAlertDialogBox(
      {required BuildContext context, dynamic state}) {
    // if (state is GroceryItemsLoadedState) {}
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Grocery'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _itemTextField(),
                      const SizedBox(
                        height: 10,
                      ),
                      _quantityTextField(),
                      const SizedBox(
                        height: 10,
                      ),
                      _expiryDateTextField(context),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<GroceryItemsBloc>().add(AddGroceryItemsEvent(
                      item: _itemsController.text,
                      expiryDate: _expiryDateController.text,
                      id: DateTime.now().millisecondsSinceEpoch,
                      quantity: int.parse(_quantityController.text),
                      quantityMeasurementUnits: _selectedItem!));
                  _expiryDateController.clear();
                  _itemsController.clear();
                  _quantityController.clear();
                  Navigator.of(context).pop();
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

  TextFormField _itemTextField() {
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
          isDense: true,
          label: const Text("Add Items"),
          hintText: "Ex: Tomatoes, Bread, Suger",
          hintStyle: TextStyle(color: Colors.grey[400])),
    );
  }

  Widget _quantityTextField() {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: TextFormField(
              autocorrect: true,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please add  Qty ";
                }
                return null;
              },
              controller: _quantityController,
              decoration: InputDecoration(
                  isDense: true,
                  label: const Text("Add Quantity"),
                  hintText: "1",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            )),
        SizedBox(
          width: 20,
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          width: 100,
          child: DropdownButton<String>(
            isDense: true,
            value: _selectedItem,
            hint: Text(
              'kg',
              style: TextStyle(color: Colors.grey[400]),
            ),
            items: _items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedItem = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  TextFormField _expiryDateTextField(BuildContext context) {
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
          label: const Text("Add expiry date"),
          hintText: "Ex: 02/12/2024",
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
