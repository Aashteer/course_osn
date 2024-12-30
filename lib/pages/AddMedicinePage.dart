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
  final TextEditingController _salesInvoiceinvoiceNumberController = TextEditingController();
  final TextEditingController _salesInvoiceissueDateController = TextEditingController();
  final TextEditingController _salesInvoicecustomerController = TextEditingController();
  final TextEditingController _salesInvoicemedicinesController = TextEditingController();
  final TextEditingController _salesInvoicetotalAmountController = TextEditingController();
  final TextEditingController _salesInvoicesellerNameController = TextEditingController();
    final TextEditingController _medicinenameController = TextEditingController();
final TextEditingController _medicinecategoryController = TextEditingController();
final TextEditingController _medicineexpirationDateController = TextEditingController();
final TextEditingController _medicineregistrationNumberController = TextEditingController();
final TextEditingController _medicinemanufacturerController = TextEditingController();
final TextEditingController _medicinepackagingTypeController = TextEditingController();
final TextEditingController _medicinepriceController = TextEditingController();

    final TextEditingController _medicineproductionDateController = TextEditingController();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  List<String> medicineList = [];
  List<Customer> customerList = [];
  List<Supplier> supplierList = [];
final TextEditingController _customerAddressController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _customerInnController = TextEditingController();

  // Поля для ввода данных поставщика

  final TextEditingController _supplierAddressController = TextEditingController();
  final TextEditingController _supplierPhoneController = TextEditingController();
  final TextEditingController _supplierBankController = TextEditingController();
  final TextEditingController _supplierAccountNumberController = TextEditingController();
  final TextEditingController _supplierInnController = TextEditingController();


  // Метод для сохранения поставщика в JSON файл
  Future<void> _saveSupplierToFile(Supplier supplier) async {
  
  final file = File('assets/supplier.json');

  // Читаем текущее содержимое файла
  List<Supplier> suppliers = [];
  if (await file.exists()) {
    String contents = await file.readAsString();
    if (contents.isNotEmpty) {
      // Декодируем JSON
      Map<String, dynamic> jsonMap = json.decode(contents);
      // Проверяем, существует ли ключ "suppliers"
      if (jsonMap.containsKey('suppliers')) {
        List<dynamic> jsonList = jsonMap['suppliers'];
        suppliers = jsonList.map((json) => Supplier.fromJson(json)).toList();
      }
    }
  }

  // Добавляем нового поставщика
  suppliers.add(supplier);

  // Создаем новый объект JSON для записи
  Map<String, dynamic> newJsonMap = {
    'suppliers': suppliers.map((s) => s.toJson()).toList(),
  };

  // Сохраняем обновленный список обратно в файл
  String jsonString = json.encode(newJsonMap);
  await file.writeAsString(jsonString);
}
  // Добавление нового поставщика
  void _addSupplier() {
    if (_supplierNameController.text.isNotEmpty) {
      // Создаем нового поставщика
      final newSupplier = Supplier(
        name: _supplierNameController.text,
        address: _supplierAddressController.text,
        phone: _supplierPhoneController.text,
        bank: _supplierBankController.text,
        accountNumber: _supplierAccountNumberController.text,
        inn: _supplierInnController.text,
      );

      // Сохраняем поставщика в файл
      _saveSupplierToFile(newSupplier);

      // Добавляем поставщика в список для отображения
      setState(() {
        supplierList.add(newSupplier);
        // Очищаем поля ввода после добавления
        _supplierNameController.clear();
        _supplierAddressController.clear();
        _supplierPhoneController.clear();
        _supplierBankController.clear();
        _supplierAccountNumberController.clear();
        _supplierInnController.clear();
      });

      // Сообщение об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Поставщик добавлен: ${newSupplier.name}')),
      );
    }
  }

  Future<List<Customer>> _loadCustomers(String filePath) async {
  try {
    final file = File(filePath);
    if (await file.exists()) {
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return (json['customers'] as List)
          .map((customerJson) => Customer.fromJson(customerJson))
          .toList();
    }
  } catch (e) {
    print('Ошибка при загрузке покупателей: $e');
  }
  return []; // Возвращаем пустой список, если файл не существует или произошла ошибка
}

  void _addCustomer() async {
  if (_customerNameController.text.isNotEmpty) {
    // Создаем нового покупателя
    final newCustomer = Customer(
      name: _customerNameController.text,
      address: _customerAddressController.text,
      phone: _customerPhoneController.text,
      inn: _customerInnController.text,
    );

    // Добавляем покупателя в список
    setState(() {
      customerList.add(newCustomer);
      _customerNameController.clear();
      _customerAddressController.clear();
      _customerPhoneController.clear();
      _customerInnController.clear();
    });

    // Путь к файлу JSON
    final customerFilePath = 'assets/customer.json';

    // Загружаем существующих покупателей
    List<Customer> existingCustomers = await _loadCustomers(customerFilePath);

    // Добавляем нового покупателя в существующий список
    existingCustomers.add(newCustomer);

    // Сохраняем обновленный список покупателей
    await _saveCustomers(customerFilePath, existingCustomers);
    
    // Сообщение об успехе
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Покупатель добавлен: ${newCustomer.name}')),
    );
  }
}

  void _addMedicine() {
    if (_medicineController.text.isNotEmpty) {
      setState(() {
        medicineList.add(_medicineController.text);
        // Очистка полей ввода
      _medicinenameController.clear();
      _medicinecategoryController.clear();
      _medicineproductionDateController.clear();
      _medicineexpirationDateController.clear();
      _medicineregistrationNumberController.clear();
      _medicinemanufacturerController.clear();
      _medicinepackagingTypeController.clear();
      _medicinepriceController.clear();
      }
      );
    }
  }

void _addsalesinvoice() {
  if (_medicineController.text.isNotEmpty) {
      setState(() {
        medicineList.add(_medicineController.text);
        _salesInvoiceinvoiceNumberController.clear();
        _salesInvoiceissueDateController.clear();
        _salesInvoicecustomerController.clear();
        _salesInvoicemedicinesController.clear();
        _salesInvoicetotalAmountController.clear();
        _salesInvoicesellerNameController.clear();
        }
      );
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
    final medicineFilePath = 'assets/medicine.json';
    final supplierFilePath = 'assets/supplier.json';

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Поля ввода для данных лекарств
                const SizedBox(height: 20),
                Text('Список лекарств:'),
                TextFormField(
                  controller: _medicinenameController,
                  decoration: const InputDecoration(labelText: 'Название лекарства'),
                ),
                TextFormField(
                  controller: _medicinecategoryController,
                  decoration: const InputDecoration(labelText: 'Категория'),
                ),
                TextFormField(
                  controller: _medicineproductionDateController,
                  decoration: const InputDecoration(labelText: 'Дата производства'),
                ),
                TextFormField(
                  controller: _medicineexpirationDateController,
                  decoration: const InputDecoration(labelText: 'Дата истечения срока годности'),
                ),
                TextFormField(
                  controller: _medicineregistrationNumberController,
                  decoration: const InputDecoration(labelText: 'Регистрационный номер'),
                ),
                TextFormField(
                  controller: _medicinemanufacturerController,
                  decoration: const InputDecoration(labelText: 'Производитель'),
                ),
                TextFormField(
                  controller: _medicinepackagingTypeController,
                  decoration: const InputDecoration(labelText: 'Тип упаковки'),
                ),
                TextFormField(
                  controller: _medicinepriceController,
                  decoration: const InputDecoration(labelText: 'Цена'),
                ),
                ElevatedButton(
                  onPressed: _addMedicine,
                  child: const Text('Добавить'),
                ),
                

                // Поля ввода для данных покупателя
                Text('Покупатель:'),
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
                Text('Счет-фактура:'),

                TextFormField(
                  controller: _salesInvoiceinvoiceNumberController,
                  decoration: const InputDecoration(labelText: 'Номер счета-фактуры'),
                ),
                TextFormField(
                  controller: _salesInvoiceissueDateController,
                  decoration: const InputDecoration(labelText: 'Дата выписки счета'),
                ),
                TextFormField(
                  controller: _salesInvoicecustomerController,
                  decoration: const InputDecoration(labelText: 'Покупатель'),
                ),
                TextFormField(
                  controller: _salesInvoicemedicinesController,
                  decoration: const InputDecoration(labelText: 'Лекарства, указанные в счете'),
                ),
                TextFormField(
                  controller: _salesInvoicetotalAmountController,
                  decoration: const InputDecoration(labelText: 'Сумма к уплате'),
                ),
                TextFormField(
                  controller: _salesInvoicesellerNameController,
                  decoration: const InputDecoration(labelText: 'Фамилия продавца'),
                ),
                ElevatedButton(
                  onPressed: _addsalesinvoice,
                  child: const Text('Добавить покупателя'),
                ),

                // Поля ввода для данных поставщика
                Text('Поставщики:'),
                TextFormField(
                  controller: _supplierNameController,
                  decoration: const InputDecoration(labelText: 'Имя поставщика'),
                ),
                TextFormField(
                  controller: _supplierAddressController,
                  decoration: const InputDecoration(labelText: 'Адрес поставщика'),
                ),
                TextFormField(
                  controller: _supplierPhoneController,
                  decoration: const InputDecoration(labelText: 'Телефон поставщика'),
                ),
                TextFormField(
                  controller: _supplierBankController,
                  decoration: const InputDecoration(labelText: 'Банк поставщика'),
                ),
                TextFormField(
                  controller: _supplierAccountNumberController,
                  decoration: const InputDecoration(labelText: 'Номер счета'),
                ),
                TextFormField(
                  controller: _supplierInnController,
                  decoration: const InputDecoration(labelText: 'ИНН поставщика'),
                ),
                ElevatedButton(
                  onPressed: _addSupplier,
                  child: const Text('Добавить поставщика'),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
                Text('Приходная приклодная:'),
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
                  onPressed: _submitForm,
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}