import 'dart:convert';

import 'package:course_osn/models/medicine.dart';
import 'package:flutter/services.dart';

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

   // Метод для поиска накладной по invoiceNumber в списке JSON
  static Future<Invoice> findByInvoiceNumber(String invoiceNumber) async {
  List<Invoice> invoices = await loadInvoicesFromDatabase();

  // Поиск по списку JSON-объектов
  for (var invoice in invoices) {
    if (invoice.invoiceNumber == invoiceNumber) {
      return invoice; // Возвращаем найденный экземпляр Invoice
    }
  }
  
  // Возвращаем пустой экземпляр Invoice, если не нашли
  return Invoice(
    invoiceNumber: 'Не указано', // или любое другое значение по умолчанию
    arrivalDate: DateTime.now(), // или любое значение по умолчанию
    medicines: [], // Пустой список лекарств
  );
}
  static Future<List<Invoice>> loadInvoicesFromDatabase() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/invoice.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return (json['invoices'] as List)
          .map((invoicesJson) => Invoice.fromJson(invoicesJson))
          .toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке поставщиков: $e');
    }
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
