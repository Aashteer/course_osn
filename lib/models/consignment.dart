import 'dart:convert';

import 'package:course_osn/models/customer.dart';
import 'package:course_osn/models/medicine.dart';
import 'package:course_osn/models/supplier.dart';
import 'package:flutter/services.dart';

class Consignment{
  final String number;
  final DateTime date;
  final List<String> medicineList;

  Consignment({
    required this.number,
    required this.date,
    required this.medicineList, Customer? customer, Supplier? supplier, Medicine? medicine, required List<Customer> customers, required List<Supplier> suppliers
  });
//Этот метод преобразует объект Consignment обратно в JSON-формат
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'date': date.toIso8601String(),
      'medicineList': medicineList,
    };
  }
//Этот фабричный метод создает экземпляр Consignment из JSON-объекта
  factory Consignment.fromJson(Map<String, dynamic> json) {
  return Consignment(
    number: json['number'] ?? 'Не указано',
    date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    medicineList: (json['medicineList'] as List<dynamic>?)?.cast<String>() ?? [], customers: [], suppliers: [], // Пустой список по умолчанию
  );
}

//Статический асинхронный метод, который ищет накладную по номеру счета (invoice number). Он загружает все накладные из базы данных (через метод loadInvoicesFromDatabase) и 
//ищет среди них накладную с указанным номером. Если находит, возвращает соответствующий экземпляр
// Consignment. Если не находит, возвращает пустой экземпляр с установленными значениями по умолчанию.
  static Future<Consignment> findByInvoiceNumber(String invoiceNumber) async {
  List<Consignment> invoices = await loadInvoicesFromDatabase();

  // Поиск по списку JSON-объектов
  for (var invoice in invoices) {
    if (invoice.number == invoiceNumber) {
      return invoice; // Возвращаем найденный экземпляр Invoice
    }
  }
  
  // Возвращаем пустой экземпляр Invoice (по умолчанию)
  return Consignment(
    number: 'Не указано', 
    date: DateTime.now(), 
    medicineList: [], customers: [], suppliers: [], 
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