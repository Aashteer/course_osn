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

  static Future<List<Medicine>> loadMedicinesFromDatabase() async {
    try {
      // Создаем пример объекта Medicine
      Medicine medicine = Medicine(
        name: 'Парацетамол',
        category: 'Обезболивающее',
        productionDate: DateTime(2022, 1, 1),
        expirationDate: DateTime(2025, 1, 1),
        registrationNumber: '12345',
        manufacturer: 'Производитель 1',
        packagingType: 'Пластиковая упаковка',
        price: 100.0,
        suppliers: [
          Supplier(
            name: 'Поставщик 1',
            address: 'Москва, ул. Примерная, 10',
            phone: '+7 123 456 7890',
            bank: 'Банк 1',
            accountNumber: '1234567890123456',
            inn: '1234567890',
          ),
        ],
        invoices: [],
      );

      // Создаем объект MedicineShipment с объектом Medicine
      MedicineShipment shipment = MedicineShipment(
        medicine: medicine,
        quantity: 100,
        price: 100.0,
      );

      // Создаем объект Invoice с данным MedicineShipment
      Invoice invoice = Invoice(
        invoiceNumber: 'INV123456',
        arrivalDate: DateTime(2024, 5, 1),
        medicines: [shipment],
      );

      return [
        medicine.copyWith(invoices: [invoice]), // Возвращаем список с одним объектом medicine
      ];
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
