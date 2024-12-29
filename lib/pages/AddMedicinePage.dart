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
  late String address;
  late String phone;
  late String bank;
  late String accountNumber;
  late String inn;
  late String invoiceNumber;
  late DateTime issueDate;
  late String customer;
  late String medicines;
  late double totalAmount;
  late String sellerName;
  late DateTime arrivalDate;

  // Текущий индекс выбранной секции
  int _currentSectionIndex = 0;

  // Секция для ввода данных лекарства
  Widget _medicineSection() {
    return Column(
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
          decoration: const InputDecoration(labelText: 'Дата производства'),
          onSaved: (value) => expirationDate = DateTime.parse(value!),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Дата истечения срока годности'),
          onSaved: (value) => productionDate = DateTime.parse(value!),
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
      ],
    );
  }

  // Секция для ввода данных поставщика
  Widget _supplierSection() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Имя поставщика'),
          onSaved: (value) => name = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Адрес поставщика'),
          onSaved: (value) => address = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Телефон поставщика'),
          onSaved: (value) => phone = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Банк поставщика'),
          onSaved: (value) => bank = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Номер расчетного счета в банке'),
          onSaved: (value) => accountNumber = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'ИНН поставщика'),
          onSaved: (value) => inn = value!,
        ),
      ],
    );
  }

  // Секция для ввода данных приходной накладной
  Widget _invoiceSection() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Номер приходной накладной ведомости'),
          onSaved: (value) => invoiceNumber = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Дата поступления на склад'),
          onSaved: (value) => arrivalDate = DateTime.parse(value!),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Список поступивших лекарств'),
          onSaved: (value) => medicines = value!,
        ),
      ],
    );
  }

  // Секция для ввода данных покупателя
  Widget _customerSection() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Название покупателя'),
          onSaved: (value) => name = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Адрес покупателя'),
          onSaved: (value) => address = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Телефон покупателя'),
          onSaved: (value) => phone = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'ИНН покупателя'),
          onSaved: (value) => inn = value!,
        ),
      ],
    );
  }

  // Секция для данных счета-фактуры
  Widget _invoiceDetailsSection() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Номер счета-фактуры'),
          onSaved: (value) => invoiceNumber = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Дата выписки счета'),
          onSaved: (value) => issueDate = DateTime.parse(value!),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Покупатель'),
          onSaved: (value) => customer = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Лекарства, указанные в счете'),
          onSaved: (value) => medicines = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Сумма к уплате'),
          onSaved: (value) => totalAmount = double.parse(value!),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Фамилия продавца'),
          onSaved: (value) => sellerName = value!,
        ),
      ],
    );
  }

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
              // Кнопки переключения секций
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentSectionIndex = 0;  // Секция лекарства
                      });
                    },
                    child: const Text('Лекарство'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentSectionIndex = 1;  // Секция поставщика
                      });
                    },
                    child: const Text('Поставщик'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentSectionIndex = 2;  // Секция накладной
                      });
                    },
                    child: const Text('Приходная накладная'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentSectionIndex = 3;  // Секция покупателя
                      });
                    },
                    child: const Text('Покупатель'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentSectionIndex = 4;  // Секция счета
                      });
                    },
                    child: const Text('Счет-фактура'),
                  ),
                ],
              ),

              // Отображаем текущую секцию в зависимости от выбора
              if (_currentSectionIndex == 0) _medicineSection(),
              if (_currentSectionIndex == 1) _supplierSection(),
              if (_currentSectionIndex == 2) _invoiceSection(),
              if (_currentSectionIndex == 3) _customerSection(),
              if (_currentSectionIndex == 4) _invoiceDetailsSection(),

              // Кнопка отправки формы
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
                      price: price,
                      suppliers: [],
                      invoice: invoiceNumber,
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
