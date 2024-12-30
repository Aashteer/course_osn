import 'package:course_osn/models/medicine.dart';

class MedicineShipment {
  Medicine medicine; // Лекарство
  int quantity; // Количество поступившего лекарства
  double price; // Цена лекарства

  MedicineShipment({
    required this.medicine,
    required this.quantity,
    required this.price, required String medicineName,
  });

  // Способ создания экземпляра счета-фактуры из JSON
  factory MedicineShipment.fromJson(Map<String, dynamic> json) {
    return MedicineShipment(
      price: json['price'],
      quantity: json['quantity'],
      medicine: (json['medicine'])
          .map((medicineShipmentJson) => MedicineShipment.fromJson(medicineShipmentJson))
          .toList(), medicineName: '',
    );
  }
}
