abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}
class Fuilter{
T? searchObjectByField<T extends JsonSerializable>(
  List<T> objects,       // Список объектов, которые реализуют JsonSerializable
  String field,          // Поле, по которому будет производиться поиск
  dynamic value,         // Значение, по которому ищем
) {
  for (var obj in objects) {
    // Получаем Map, с помощью метода toJson()
    var objectField = obj.toJson()[field]; // Получаем значение поля из Map
    if (objectField == value) {
      return obj;  // Возвращаем найденный объект
    }
  }
  return null;  // Если ничего не найдено, возвращаем null
}
}