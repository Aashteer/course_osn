import 'package:course_osn/models/medicine.dart';
import 'package:course_osn/pages/AddMedicinePage.dart';
import 'package:course_osn/pages/MedicineDetailPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Medicine> medicines = [];
  String selectedSort = 'По умолчанию';
  String selectedCategory = 'Все';

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    List<Medicine> loadedMedicines = await Medicine.loadMedicinesFromDatabase();
    setState(() {
      medicines = loadedMedicines;
    });
  }

  // Фильтрация и сортировка
  List<Medicine> _filterAndSortMedicines(List<Medicine> medicines) {
    List<Medicine> filteredMedicines;

    if (selectedCategory != 'Все') {
      filteredMedicines = medicines
          .where((medicine) => medicine.category == selectedCategory)
          .toList();
    } else {
      filteredMedicines = List.from(medicines);
    }

    if (selectedSort == 'От дешевого к дорогому') {
      filteredMedicines.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort == 'От дорогого к дешевому') {
      filteredMedicines.sort((a, b) => b.price.compareTo(a.price));
    }

    return filteredMedicines;
  }

  // Функция для перехода к деталям лекарства
  void _onMedicineTap(Medicine medicine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicineDetailPage(medicine: medicine),
      ),
    );
  }

  // Функция для добавления нового лекарства
  void _addMedicine(Medicine medicine) {
    setState(() {
      medicines.add(medicine);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          title: const Text('Аптечный склад'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 143, 145, 233),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Кнопка сортировки
                  DropdownButton<String>(
                    value: selectedSort,
                    icon: const Icon(Icons.sort),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSort = newValue!;
                      });
                    },
                    items: <String>[
                      'По умолчанию',
                      'От дешевого к дорогому',
                      'От дорогого к дешевому'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  // Кнопка фильтрации по категориям
                  DropdownButton<String>(
                    value: selectedCategory,
                    icon: const Icon(Icons.filter_list),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: <String>[
                      'Все',
                      'Обезболивающие',
                      'Антибиотики',
                      'Противовирусные'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Medicine>>(
        future: Medicine.loadMedicinesFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет данных'));
          }

          medicines = snapshot.data!;

          final filteredMedicines = _filterAndSortMedicines(medicines);

          return ListView.builder(
            itemCount: filteredMedicines.length,
            itemBuilder: (context, index) {
              final medicine = filteredMedicines[index];
              return ListTile(
                title: Text(medicine.name),
                subtitle: Text('${medicine.category} - ₽ ${medicine.price.toStringAsFixed(2)}'),
                onTap: () {
                  _onMedicineTap(medicine); // Переход на страницу деталей лекарства
                },
              );
            },
          );
        },
      ),
      // Нижняя панель с кнопками
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Переход на главную страницу
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              tooltip: 'Главная',
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addmedicinepage(),
                  ),
                );
              },
              tooltip: 'Добавить лекарство',
            ),
          ],
        ),
      ),
    );
  }
}
