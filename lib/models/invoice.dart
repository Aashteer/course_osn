import 'dart:convert';

import 'package:course_osn/models/medicine.dart';
import 'package:course_osn/models/medicineshipment.dart';
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
  // Способ создания экземпляра счета-фактуры из JSON
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
  
  // Возвращаем пустой экземпляр Invoice
  return Invoice(
    invoiceNumber: 'Не указано', 
    arrivalDate: DateTime.now(), 
    medicines: [], 
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


