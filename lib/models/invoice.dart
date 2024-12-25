import 'package:course_osn/models/medicine.dart';

class Invoice {
  String invoiceNumber; // Номер приходной накладной ведомости
  DateTime arrivalDate; // Дата поступления на склад
  List<MedicineShipment> medicines; // Список поступивших лекарств

  Invoice({
    required this.invoiceNumber,
    required this.arrivalDate,
    required this.medicines,
  });
}

class MedicineShipment {
  Medicine medicine; // Лекарство
  int quantity; // Количество поступившего лекарства
  double price; // Цена лекарства

  MedicineShipment({
    required this.medicine,
    required this.quantity,
    required this.price,
  });
}
