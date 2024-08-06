import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/logic/bloc/grocery_items/grocery_items_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class UpdateGroceryItems extends StatefulWidget {
  UpdateGroceryItems(
      {super.key,
      required this.expiryDate,
      required this.id,
      required this.quantity,
      required this.index,
      required this.itemName});
  String itemName;
  String expiryDate;
  int quantity;
  int index;
  int id;

  @override
  State<UpdateGroceryItems> createState() => _UpdateGroceryItemsState();
}

class _UpdateGroceryItemsState extends State<UpdateGroceryItems> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController itemsUpdatedController;

  late TextEditingController expiryDateUpdateController;

  late TextEditingController quantityUpdateController;

  String? _selectedItem;

  final List<String> _items = ['Kg', 'Gm', 'Pkg', 'Lt', "Dozen", "Bottle"];

  @override
  void initState() {
    super.initState();
    itemsUpdatedController = TextEditingController(text: widget.itemName);
    expiryDateUpdateController = TextEditingController(text: widget.expiryDate);
    quantityUpdateController =
        TextEditingController(text: widget.quantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 0.5,
          foregroundColor: Colors.black,
          title: Text(
            "Update Grocery",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: BlocBuilder<GroceryItemsBloc, GroceryItemsState>(
          builder: (context, state) {
           if(state is GroceryItemsLoadedState){
             return Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, bottom: 10, right: 20),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _itemTextField(),
                        const SizedBox(
                          height: 20,
                        ),
                        _quantityTextField(),
                        const SizedBox(
                          height: 20,
                        ),
                        _expiryDateTextField(context),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      child: const Text("Update"),
                      onPressed: () {
                        // print("    updateitem: ${itemsUpdatedController.text}, index: ${widget.index}, updateExpiryDate:${ expiryDateUpdateController.text},id: widget.id,quantity:${ int.parse(quantityUpdateController.text)}");
                        if (_formKey.currentState!.validate()) {
                          context.read<GroceryItemsBloc>().add(
                              UpdateGroceryItemsEvent(
                                  updateitem: itemsUpdatedController.text,
                                  index: widget.index,
                                  updateExpiryDate:
                                      expiryDateUpdateController.text,
                                  id: widget.id,
                                  quantity: int.parse(
                                      quantityUpdateController.text)));
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                ],
              ),
            );
           }else{
            return Container();
          }
          }
        ));
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
      controller: itemsUpdatedController,
      decoration: InputDecoration(
          isDense: true,
          label: const Text("Update Items"),
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
              controller: quantityUpdateController,
              decoration: InputDecoration(
                  isDense: true,
                  label: const Text("Update Quantity"),
                  hintText: "1 kg",
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
            hint: Text('kg'),
            items: _items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {},
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
      controller: expiryDateUpdateController,
      decoration: InputDecoration(
          label: const Text("Update expiry date"),
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
        expiryDateUpdateController.text = date.toString().split(" ")[0];
      },
    );
  }
}
