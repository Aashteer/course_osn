import 'package:course_osn/models/medicine.dart';
import 'package:flutter/material.dart';

class AddMedicinePage extends StatefulWidget {
  final Function(Medicine) onAddMedicine;

  const AddMedicinePage({super.key, required this.onAddMedicine});

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String category;
  late DateTime productionDate;
  late DateTime expirationDate;
  late String registrationNumber;
  late String manufacturer;
  late String packagingType;
  late double price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить лекарство'),
        backgroundColor: const Color.fromARGB(255, 143, 145, 233),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Название лекарства'),
                onSaved: (value) => name = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название лекарства';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Категория'),
                onSaved: (value) => category = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите категорию';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Регистрационный номер'),
                onSaved: (value) => registrationNumber = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Производитель'),
                onSaved: (value) => manufacturer = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Тип упаковки'),
                onSaved: (value) => packagingType = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Цена'),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newMedicine = Medicine(
                      name: name,
                      category: category,
                      productionDate: productionDate,
                      expirationDate: expirationDate,
                      registrationNumber: registrationNumber,
                      manufacturer: manufacturer,
                      packagingType: packagingType,
                      price: price, suppliers: [], invoices: [],
                    );

                    widget.onAddMedicine(newMedicine);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
