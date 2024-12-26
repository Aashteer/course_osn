import 'dart:convert';
import 'package:flutter/services.dart'; // Импортируйте этот пакет
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
  List<Invoice> invoices;

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
    required this.invoices,
  });

  // Метод для создания экземпляра Medicine из JSON
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      category: json['category'],
      productionDate: DateTime.parse(json['productionDate']),
      expirationDate: DateTime.parse(json['expirationDate']),
      registrationNumber: json['registrationNumber'],
      manufacturer: json['manufacturer'],
      packagingType: json['packagingType'],
      price: json['price'].toDouble(),
      suppliers: (json['suppliers'] as List)
          .map((supplierJson) => Supplier.fromJson(supplierJson))
          .toList(),
      invoices: (json['invoices'] as List)
          .map((invoiceJson) => Invoice.fromJson(invoiceJson))
          .toList(),
    );
  }

  static Future<List<Medicine>> loadMedicinesFromDatabase() async {
    try {
      // Загружаем содержимое файла JSON
      final String response = await rootBundle.loadString('assets/medicine.json');
      final Map<String, dynamic> decodedJson = jsonDecode(response);
      List<dynamic> medicinesJson = decodedJson['medicines'];

      // Создаем список объектов Medicine из JSON
      List<Medicine> medicines = medicinesJson
          .map((medicineJson) => Medicine.fromJson(medicineJson))
          .toList();

      return medicines;
    } catch (e) {
      throw Exception('Ошибка при загрузке данных: $e');
    }
  }

  Medicine copyWith({
    String? name,
    String? category,
    DateTime? productionDate,
    DateTime? expirationDate,
    String? registrationNumber,
    String? manufacturer,
    String? packagingType,
    double? price,
    List<Supplier>? suppliers,
    List<Invoice>? invoices,
  }) {
    return Medicine(
      name: name ?? this.name,
      category: category ?? this.category,
      productionDate: productionDate ?? this.productionDate,
      expirationDate: expirationDate ?? this.expirationDate,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      manufacturer: manufacturer ?? this.manufacturer,
      packagingType: packagingType ?? this.packagingType,
      price: price ?? this.price,
      suppliers: suppliers ?? this.suppliers,
      invoices: invoices ?? this.invoices,
    );
  }
}
