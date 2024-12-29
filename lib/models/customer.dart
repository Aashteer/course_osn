import 'dart:convert';
import 'package:flutter/services.dart'; // Не забудьте импортировать этот пакет, если еще не сделали это.

class Customer {
  String name;       // Название покупателя
  String address;    // Адрес покупателя
  String phone;      // Телефон покупателя
  String inn;        // ИНН покупателя

  Customer({
    required this.name,
    required this.address,
    required this.phone,
    required this.inn,
  });

  // Метод для создания экземпляра Customer из JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      inn: json['inn'],
    );
  }
  
// Метод для преобразования объекта Customer в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'inn': inn,
    };
  }

  // Метод для загрузки списка покупателей из JSON файла
  static Future<List<Customer>> loadCustomersFromDatabase() async {
    try {
      // Загружаем содержимое файла JSON
      final String response = await rootBundle.loadString('assets/customer.json');
      final Map<String, dynamic> decodedJson = jsonDecode(response);
      List<dynamic> customersJson = decodedJson['customer'];

      // Создаем список объектов Customer из JSON
      List<Customer> customers = customersJson
          .map((customerJson) => Customer.fromJson(customerJson))
          .toList();

      return customers;
    } catch (e) {
      throw Exception('Ошибка при загрузке данных покупателей: $e');
    }
  }
}
