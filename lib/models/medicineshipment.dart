class MedicineShipment {
  String medicineName;  // Название лекарства
  int quantity;         // Количество лекарства
  double price;         // Цена за единицу лекарства

  MedicineShipment({
    required this.medicineName,
    required this.quantity,
    required this.price,
  });

  // Метод для создания экземпляра MedicineShipment из JSON
  factory MedicineShipment.fromJson(Map<String, dynamic> json) {
    return MedicineShipment(
      medicineName: json['medicineName'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'quantity': quantity,
      'price': price,
    };
  }
}

