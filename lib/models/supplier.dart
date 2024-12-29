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
      final String jsonString = await rootBundle.loadString('assets/supplier.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return (json['suppliers'] as List)
          .map((supplierJson) => Supplier.fromJson(supplierJson))
          .toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке поставщиков: $e');
    }
  }
  

  @override
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
  
}
