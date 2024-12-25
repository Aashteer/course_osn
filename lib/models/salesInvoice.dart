import 'package:course_osn/models/customer.dart';
import 'package:course_osn/models/invoice.dart';

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
}
