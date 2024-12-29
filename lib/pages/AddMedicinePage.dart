import 'dart:io';
import 'package:course_osn/models/consignment.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Addmedicinepage extends StatefulWidget {
  const Addmedicinepage({super.key});

  @override
  State<Addmedicinepage> createState() => _AddmedicinepageState();
}

class _AddmedicinepageState extends State<Addmedicinepage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _medicineController = TextEditingController();

  List<String> _medicineList = [];

  Future<void> _saveConsignmentToFile(String json) async {
    final file = File('assets/consignments.json');

    // Если файл существует, добавляем новый JSON к существующим данным
    if (await file.exists()) {
      String existingData = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(existingData);
      jsonData.add(jsonDecode(json));
      await file.writeAsString(jsonEncode(jsonData));
    } else {
      // Если файл не существует, создаем новый
      await file.writeAsString(jsonEncode([jsonDecode(json)]));
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newConsignment = Consignment(
        number: _numberController.text,
        date: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
        medicineList: _medicineList,
      );

      // Преобразуем данные в JSON
      final consignmentJson = jsonEncode(newConsignment.toJson());
      print('Созданный Consignment: $consignmentJson');

      // Сохраняем JSON в файл
      await _saveConsignmentToFile(consignmentJson);

      // Очищаем форму после отправки
      _formKey.currentState!.reset();
      _medicineList.clear();
      setState(() {});
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
          child: ListView(
            children: [
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'Номер накладной',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите номер накладной';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Дата (YYYY-MM-DD)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите дату';
                  }
                  // Проверка формата даты
                  if (DateTime.tryParse(value) == null) {
                    return 'Пожалуйста, введите дату в формате YYYY-MM-DD';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _medicineController,
                decoration: const InputDecoration(
                  labelText: 'Лекарство',
                  hintText: 'Введите название лекарства и нажмите Добавить',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_medicineController.text.isNotEmpty) {
                    setState(() {
                      _medicineList.add(_medicineController.text);
                      _medicineController.clear();
                    });
                  }
                },
                child: const Text('Добавить лекарство'),
              ),
              const SizedBox(height: 10),
              if (_medicineList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Список лекарств:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ..._medicineList.map((medicine) => ListTile(
                          title: Text(medicine),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _medicineList.remove(medicine);
                              });
                            },
                          ),
                        )),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Сохранить накладную'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
