import 'dart:convert';

import 'package:flutter/services.dart';

class Consignment{
  final String number;
  final DateTime date;
  final List<String> medicineList;

  Consignment({
    required this.number,
    required this.date,
    required this.medicineList
  });
  
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'date': date.toIso8601String(),
      'medicineList': medicineList,
    };
  }

  factory Consignment.fromJson(Map<String, dynamic> json) {
  return Consignment(
    number: json['number'] ?? 'Не указано',
    date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    medicineList: (json['medicineList'] as List<dynamic>?)?.cast<String>() ?? [], // Пустой список по умолчанию
  );
}


  static Future<Consignment> findByInvoiceNumber(String invoiceNumber) async {
  List<Consignment> invoices = await loadInvoicesFromDatabase();

  // Поиск по списку JSON-объектов
  for (var invoice in invoices) {
    if (invoice.number == invoiceNumber) {
      return invoice; // Возвращаем найденный экземпляр Invoice
    }
  }
  
  // Возвращаем пустой экземпляр Invoice, если не нашли
  return Consignment(
    number: 'Не указано', // или любое другое значение по умолчанию
    date: DateTime.now(), // или любое значение по умолчанию
    medicineList: [], // Пустой список лекарств
  );
}
  static Future<List<Consignment>> loadInvoicesFromDatabase() async {
  try {
    final String jsonString = await rootBundle.loadString('assets/consignment.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    print('Загруженные накладные: $json'); // Логирование загруженных данных
    return (json['consignment'] as List)
        .map((invoicesJson) => Consignment.fromJson(invoicesJson))
        .toList();
  } catch (e) {
    print('Ошибка при загрузке накладных: $e');
    throw Exception('Ошибка при загрузке накладных: $e');
  }
}

}