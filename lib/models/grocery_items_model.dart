class GroceryItemsModel {
    GroceryItemsModel({
        required this.items,
    });

    final List<Item> items;

    GroceryItemsModel copyWith(Item obj, {
        List<Item>? items,
    }) {
        return GroceryItemsModel(
            items: items ?? this.items,
        );
    }

    factory GroceryItemsModel.fromJson(Map<String, dynamic> json){ 
        return GroceryItemsModel(
            items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "items": items.map((x) => x.toJson()).toList(),
    };

}

class Item {
    Item({
        required this.groceryId,
        required this.expiryDate,
        required this.itemName,
        required this.quantity,
        required this.units
    });

    final int groceryId;
    final String expiryDate;
    final String itemName;
     final int quantity;
     final String units;

    Item copyWith({
        int? groceryId,
        String? expiryDate,
        String? itemName,
        int? quantity,
        String? units
    }) {
        return Item(
            groceryId: groceryId ?? this.groceryId,
            expiryDate: expiryDate ?? this.expiryDate,
            itemName: itemName ?? this.itemName,
            quantity:quantity ?? this.quantity,
            units:units??this.units
        );
    }

    factory Item.fromJson(Map<String, dynamic> json){ 
        return Item(
            groceryId: json["grocery_id"],
            expiryDate: json["expiry_date"],
            itemName: json["item_name"],
            quantity:json["quantity"],
            units:json["units"]
        );
    }

    Map<String, dynamic> toJson() => {
        "grocery_id": groceryId,
        "expiry_date": expiryDate,
        "item_name": itemName,
        "quantity":quantity,
        "units":units
    };

}
