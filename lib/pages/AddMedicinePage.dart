import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:course_osn/models/consignment.dart';
import 'package:course_osn/models/medicine.dart';
import 'package:course_osn/models/customer.dart';
import 'package:course_osn/models/supplier.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  List<String> medicineList = [];
  List<Customer> customerList = [];
  List<Supplier> supplierList = [];
final TextEditingController _customerAddressController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _customerInnController = TextEditingController();

  void _addCustomer() {
    if (_customerNameController.text.isNotEmpty) {
      setState(() {
        customerList.add(Customer(
          name: _customerNameController.text,
          address: _customerAddressController.text,
          phone: _customerPhoneController.text,
          inn: _customerInnController.text,
        ));
        _customerNameController.clear();
        _customerAddressController.clear();
        _customerPhoneController.clear();
        _customerInnController.clear();
      });
    }
  }
  void _addMedicine() {
    if (_medicineController.text.isNotEmpty) {
      setState(() {
        medicineList.add(_medicineController.text);
        _medicineController.clear(); // Очищаем поле ввода после добавления
      });
    }
  }


  void _addSupplier() {
    if (_supplierNameController.text.isNotEmpty) {
      setState(() {
        supplierList.add(Supplier(name: _supplierNameController.text, address: '', phone: '', bank: '', accountNumber: '', inn: ''));
        _supplierNameController.clear(); // Очищаем поле ввода после добавления
      });
    }
  }

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    // Создаем экземпляр Consignment
    final consignment = Consignment(
      number: _numberController.text,
      date: DateTime.parse(_dateController.text),
      medicineList: medicineList,
      customers: customerList,
      suppliers: supplierList,
    );

    // Получаем путь к файлу JSON
    final consignmentFilePath = 'assets/consignment.json';
    final customerFilePath = 'assets/customer.json';

    // Загружаем существующие накладные
    List<Consignment> existingConsignments = await _loadConsignments(consignmentFilePath);

    // Добавляем новый экземпляр в список
    existingConsignments.add(consignment);

    // Перезаписываем файл JSON с новым списком накладных
    await _saveConsignments(consignmentFilePath, existingConsignments);

    // Сохраняем покупателей в JSON
    await _saveCustomers(customerFilePath, customerList);

    // Сообщение об успехе
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Накладная добавлена: ${consignment.number}')),
    );

    // Очистка формы
    _formKey.currentState!.reset();
    setState(() {
      medicineList.clear();
      customerList.clear();
      supplierList.clear();
    });
  }
}


  Future<List<Consignment>> _loadConsignments(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final String jsonString = await file.readAsString();
        final Map<String, dynamic> json = jsonDecode(jsonString);
        return (json['consignment'] as List)
            .map((invoicesJson) => Consignment.fromJson(invoicesJson))
            .toList();
      }
    } catch (e) {
      print('Ошибка при загрузке накладных: $e');
    }
    return []; // Возвращаем пустой список, если файл не существует или произошла ошибка
  }
  Future<void> _saveCustomers(String filePath, List<Customer> customers) async {
    try {
      final file = File(filePath);
      final jsonString = jsonEncode({
        'customers': customers.map((c) => c.toJson()).toList(),
      });
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Ошибка при сохранении покупателей: $e');
    }
  }

  Future<void> _saveConsignments(String filePath, List<Consignment> consignments) async {
    try {
      final file = File(filePath);
      final jsonString = jsonEncode({
        'consignment': consignments.map((c) => c.toJson()).toList(),
      });
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Ошибка при сохранении накладных: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить накладную'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              ElevatedButton(
                onPressed: _addCustomer,
                child: const Text('Добавить покупателя'),
              ),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Номер накладной'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите номер накладной';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Дата (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите дату';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _medicineController,
                decoration: const InputDecoration(labelText: 'Лекарство'),
              ),
              ElevatedButton(
                onPressed: _addMedicine,
                child: const Text('Добавить лекарство'),
              ),
              const SizedBox(height: 20),
              Text('Список лекарств:'),
              Expanded(
                child: ListView.builder(
                  itemCount: medicineList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(medicineList[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            medicineList.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: 'Имя покупателя'),
              ),
              TextFormField(
                controller: _customerAddressController,
                decoration: const InputDecoration(labelText: 'Адрес покупателя'),
              ),
              TextFormField(
                controller: _customerPhoneController,
                decoration: const InputDecoration(labelText: 'Телефон покупателя'),
              ),
              TextFormField(
                controller: _customerInnController,
                decoration: const InputDecoration(labelText: 'ИНН покупателя'),
              ),
              
              ElevatedButton(
                onPressed: _addCustomer,
                child: const Text('Добавить покупателя'),
              ),
              const SizedBox(height: 20),
              Text('Список покупателей:'),
              Expanded(
                child: ListView.builder(
                  itemCount: customerList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(customerList[index].name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            customerList.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              TextFormField(
                controller: _supplierNameController,
                decoration: const InputDecoration(labelText: 'Поставщик'),
              ),
              ElevatedButton(
                onPressed: _addSupplier,
                child: const Text('Добавить поставщика'),
              ),
              const SizedBox(height: 20),
              Text('Список поставщиков:'),
              Expanded(
                child: ListView.builder(
                  itemCount: supplierList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(supplierList[index].name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            supplierList.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
