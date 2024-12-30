import 'dart:convert';
import 'package:course_osn/models/customer.dart';
import 'package:course_osn/models/invoice.dart';
import 'package:flutter/services.dart';


class SalesInvoice {
  String invoiceNumber;   // Номер счета-фактуры
  DateTime issueDate;     // Дата выписки счета
  Customer customer;      // Покупатель
  List<MedicineShipment> medicines;  // Лекарства, указанные в счете
  double totalAmount;     // Сумма к уплате
  String sellerName;      // Фамилия продавца

  SalesInvoice({
    required this.invoiceNumber,
    required this.issueDate,
    required this.customer,
    required this.medicines,
    required this.totalAmount,
    required this.sellerName,
  });

  // Метод для подсчета общей суммы
  void calculateTotalAmount() {
    totalAmount = medicines.fold(0.0, (sum, shipment) {
      return sum + (shipment.quantity * shipment.price);
    });
  }

  // Метод для создания экземпляра SalesInvoice из JSON
  factory SalesInvoice.fromJson(Map<String, dynamic> json) {
    var medicinesJson = json['medicines'] as List;
    List<MedicineShipment> medicinesList = medicinesJson
        .map((medicineJson) => MedicineShipment.fromJson(medicineJson))
        .toList();

    return SalesInvoice(
      invoiceNumber: json['invoiceNumber'],
      issueDate: DateTime.parse(json['issueDate']),
      customer: Customer.fromJson(json['customer']),
      medicines: medicinesList,
      totalAmount: json['totalAmount'].toDouble(),
      sellerName: json['sellerName'],
    );
  }
  

  // Метод для загрузки списка счетов-фактур из JSON файла
  static Future<List<SalesInvoice>> loadInvoicesFromDatabase() async {
    try {
      // Загружаем содержимое файла JSON
      final String response = await rootBundle.loadString('assets/invoices.json');
      final Map<String, dynamic> decodedJson = jsonDecode(response);
      List<dynamic> invoicesJson = decodedJson['invoices'];

      // Создаем список объектов SalesInvoice из JSON
      List<SalesInvoice> invoices = invoicesJson
          .map((invoiceJson) => SalesInvoice.fromJson(invoiceJson))
          .toList();

      return invoices;
    } catch (e) {
      throw Exception('Ошибка при загрузке данных счетов-фактур: $e');
    }
  }
  
}
