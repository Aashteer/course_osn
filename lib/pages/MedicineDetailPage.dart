import 'package:course_osn/models/invoice.dart';
import 'package:course_osn/models/medicine.dart';
import 'package:flutter/material.dart';

class MedicineDetailPage extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
        backgroundColor: const Color.fromARGB(255, 143, 145, 233),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Название лекарства'),
              subtitle: Text(medicine.name),
            ),
            ListTile(
              title: const Text('Категория'),
              subtitle: Text(medicine.category),
            ),
            ListTile(
              title: const Text('Дата производства'),
              subtitle: Text(medicine.productionDate.toLocal().toString().split(' ')[0]),
            ),
            ListTile(
              title: const Text('Дата истечения срока годности'),
              subtitle: Text(medicine.expirationDate.toLocal().toString().split(' ')[0]),
            ),
            ListTile(
              title: const Text('Регистрационный номер'),
              subtitle: Text(medicine.registrationNumber),
            ),
            ListTile(
              title: const Text('Производитель'),
              subtitle: Text(medicine.manufacturer),
            ),
            ListTile(
              title: const Text('Тип упаковки'),
              subtitle: Text(medicine.packagingType),
            ),
            ListTile(
              title: const Text('Цена'),
              subtitle: Text('₽ ${medicine.price.toStringAsFixed(2)}'),
            ),
            const Divider(),
            const Text('Поставщики', style: TextStyle(fontWeight: FontWeight.bold)),
            ...medicine.suppliers.map(
              (supplier) => ListTile(
                title: Text(supplier.name),
                subtitle: Text('${supplier.phone}, ${supplier.address}'),
              ),
            ).toList(),
            const Divider(),
            const Text('Приходные накладные', style: TextStyle(fontWeight: FontWeight.bold)),
            ...medicine.invoices.map(
              (invoice) => ListTile(
                title: Text('№ ${invoice.invoiceNumber} от ${invoice.arrivalDate.toLocal().toString().split(' ')[0]}'),
                subtitle: Text('Количество: ${invoice.medicines.length} на сумму: ₽ ${_calculateTotalInvoiceAmount(invoice)}'),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  double _calculateTotalInvoiceAmount(Invoice invoice) {
    return invoice.medicines.fold(0.0, (sum, shipment) {
      return sum + (shipment.quantity * shipment.price);
    });
  }
}
