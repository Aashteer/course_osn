import 'dart:convert';
import 'package:flutter/services.dart'; // Не забудьте импортировать этот пакет, если еще не сделали это.

class Supplier {
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

  // Метод для создания экземпляра Supplier из JSON
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

  // Метод для загрузки списка поставщиков из JSON файла
  static Future<List<Supplier>> loadSuppliersFromDatabase() async {
    try {
      // Загружаем содержимое файла JSON
      final String response = await rootBundle.loadString('assets/suppliers.json');
      final Map<String, dynamic> decodedJson = jsonDecode(response);
      List<dynamic> suppliersJson = decodedJson['suppliers'];

      // Создаем список объектов Supplier из JSON
      List<Supplier> suppliers = suppliersJson
          .map((supplierJson) => Supplier.fromJson(supplierJson))
          .toList();

      return suppliers;
    } catch (e) {
      throw Exception('Ошибка при загрузке данных поставщиков: $e');
    }
  }
}
