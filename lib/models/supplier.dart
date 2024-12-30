import 'dart:convert';
import 'package:course_osn/components/search.dart';
import 'package:flutter/services.dart'; 

class Supplier extends JsonSerializable {
  String name; // Название поставщика
  String address; // Адрес поставщика
  String phone; // Телефон поставщика
  String bank; // Банк поставщика
  String accountNumber; // Номер расчетного счета в банке
  String inn; // ИНН поставщика

  Supplier({
    required this.name,
    required this.address,
    required this.phone,
    required this.bank,
    required this.accountNumber,
    required this.inn,
  });
  
  // Этот фабричный метод создает экземпляр Supplier из JSON-объекта
  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      bank: json['bank'],
      accountNumber: json['accountNumber'],
      inn: json['inn'],
    );
  }
  
   // Этот метод преобразует объект Supplier обратно в JSON-формат
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'bank': bank,
      'accountNumber': accountNumber,
      'inn': inn,
    };
  }

  // Метод для загрузки списка поставщиков из JSON файла
static Future<List<Supplier>> loadSuppliersFromDatabase() async {
  try {
    // Загружаем содержимое файла JSON
    final String jsonString = await rootBundle.loadString('assets/supplier.json');
    final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
    
    // Получаем список поставщиков из JSON
    List<dynamic> suppliersJson = decodedJson['suppliers'];

    // Создаем список объектов Supplier из JSON
    List<Supplier> suppliers = suppliersJson
        .map((supplierJson) => Supplier.fromJson(supplierJson))
        .toList();

    return suppliers;
  } catch (e) {
    throw Exception('Ошибка при загрузке поставщиков: $e');
  }
}

}

