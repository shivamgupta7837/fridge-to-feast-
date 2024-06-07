import 'package:equatable/equatable.dart';

class GroceryItemsModel extends Equatable{
final String items;
final String expiryDate;

  GroceryItemsModel({required this.items, required this.expiryDate});
  
  @override
  // TODO: implement props
  List<Object?> get props => [items, expiryDate];
}