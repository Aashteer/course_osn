import 'package:course_osn/models/medicine.dart';

class Invoice {
  String invoiceNumber; // Номер приходной накладной ведомости
  DateTime arrivalDate; // Дата поступления на склад
  List<MedicineShipment> medicines; // Список поступивших лекарств

  Invoice({
    required this.invoiceNumber,
    required this.arrivalDate,
    required this.medicines,
  });
  // Method to create an Invoice instance from JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceNumber: json['invoiceNumber'],
      arrivalDate: DateTime.parse(json['arrivalDate']),
      medicines: (json['medicines'] as List)
          .map((medicineShipmentJson) => MedicineShipment.fromJson(medicineShipmentJson))
          .toList(),
    );
  }
}

class MedicineShipment {
  Medicine medicine; // Лекарство
  int quantity; // Количество поступившего лекарства
  double price; // Цена лекарства

  MedicineShipment({
    required this.medicine,
    required this.quantity,
    required this.price,
  });

  // Method to create an Invoice instance from JSON
  factory MedicineShipment.fromJson(Map<String, dynamic> json) {
    return MedicineShipment(
      price: json['price'],
      quantity: json['quantity'],
      medicine: (json['medicine'])
          .map((medicineShipmentJson) => MedicineShipment.fromJson(medicineShipmentJson))
          .toList(),
    );
  }
}
