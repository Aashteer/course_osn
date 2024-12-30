import 'dart:convert';
import 'package:flutter/services.dart'; 
import 'package:course_osn/components/search.dart'; 
import 'package:course_osn/models/invoice.dart'; 
import 'package:course_osn/models/supplier.dart'; 

class Medicine {
  String name;
  String category;
  DateTime productionDate;
  DateTime expirationDate;
  String registrationNumber;
  String manufacturer;
  String packagingType;
  double price;
  List<Supplier> suppliers;
  String invoice;

  Medicine({
    required this.name,
    required this.category,
    required this.productionDate,
    required this.expirationDate,
    required this.registrationNumber,
    required this.manufacturer,
    required this.packagingType,
    required this.price,
    required this.suppliers,
    required this.invoice,
  });

  // Асинхронный фабричный метод
  static Future<Medicine> fromJsonAsync(Map<String, dynamic> json) async {
    // Загружаем всех поставщиков
    List<Supplier> allSuppliers = await Supplier.loadSuppliersFromDatabase();
    Fuilter filter = Fuilter();

    // Обрабатываем массив строк `suppliers` из JSON
    List<String> supplierNames = List<String>.from(json['suppliers']);
    List<Supplier> foundSuppliers = supplierNames.map(
      (supplierName) {
        return filter.searchObjectByField<Supplier>(
          allSuppliers,
          'name',
          supplierName,
        )!;
      },
    ).toList();

    return Medicine(
      name: json['name'],
      category: json['category'],
      productionDate: DateTime.parse(json['productionDate']),
      expirationDate: DateTime.parse(json['expirationDate']),
      registrationNumber: json['registrationNumber'],
      manufacturer: json['manufacturer'],
      packagingType: json['packagingType'],
      price: json['price'].toDouble(),
      suppliers: foundSuppliers,
      invoice: json['invoice'], // Аналогично обрабатываем invoices
    );
  }

  static Future<List<Medicine>> loadMedicinesFromDatabase() async {
    try {
      final String response = await rootBundle.loadString('assets/medicine.json');
      final Map<String, dynamic> decodedJson = jsonDecode(response);
      List<dynamic> medicinesJson = decodedJson['medicines'];

      List<Medicine> medicines = await Future.wait(
        medicinesJson.map((medicineJson) => Medicine.fromJsonAsync(medicineJson)),
      );

      return medicines;
    } catch (e) {
      throw Exception('Ошибка при загрузке данных: $e');
    }
  }
  

  static fromJson(json) {}

  toJson() {}
}
