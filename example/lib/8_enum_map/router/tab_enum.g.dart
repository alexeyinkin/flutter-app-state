// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_enum.dart';

// **************************************************************************
// UnmodifiableEnumMapGenerator
// **************************************************************************

class UnmodifiableTabEnumMap<V> implements Map<TabEnum, V> {
  final V books;
  final V about;

  const UnmodifiableTabEnumMap({
    required this.books,
    required this.about,
  });

  @override
  Map<RK, RV> cast<RK, RV>() {
    return Map.castFrom<TabEnum, V, RK, RV>(this);
  }

  @override
  bool containsValue(Object? value) {
    if (this.books == value) return true;
    if (this.about == value) return true;
    return false;
  }

  @override
  bool containsKey(Object? key) {
    return key.runtimeType == TabEnum;
  }

  @override
  V? operator [](Object? key) {
    switch (key) {
      case TabEnum.books:
        return this.books;
      case TabEnum.about:
        return this.about;
    }

    return null;
  }

  @override
  void operator []=(TabEnum key, V value) {
    throw Exception("Cannot modify this map.");
  }

  @override
  Iterable<MapEntry<TabEnum, V>> get entries {
    return [
      MapEntry<TabEnum, V>(TabEnum.books, this.books),
      MapEntry<TabEnum, V>(TabEnum.about, this.about),
    ];
  }

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> transform(TabEnum key, V value)) {
    final books = transform(TabEnum.books, this.books);
    final about = transform(TabEnum.about, this.about);
    return {
      books.key: books.value,
      about.key: about.value,
    };
  }

  @override
  void addEntries(Iterable<MapEntry<TabEnum, V>> newEntries) {
    throw Exception("Cannot modify this map.");
  }

  @override
  V update(TabEnum key, V update(V value), {V Function()? ifAbsent}) {
    throw Exception("Cannot modify this map.");
  }

  @override
  void updateAll(V update(TabEnum key, V value)) {
    throw Exception("Cannot modify this map.");
  }

  @override
  void removeWhere(bool test(TabEnum key, V value)) {
    throw Exception("Objects in this map cannot be removed.");
  }

  @override
  V putIfAbsent(TabEnum key, V ifAbsent()) {
    return this.get(key);
  }

  @override
  void addAll(Map<TabEnum, V> other) {
    throw Exception("Cannot modify this map.");
  }

  @override
  V? remove(Object? key) {
    throw Exception("Objects in this map cannot be removed.");
  }

  @override
  void clear() {
    throw Exception("Objects in this map cannot be removed.");
  }

  @override
  void forEach(void action(TabEnum key, V value)) {
    action(TabEnum.books, this.books);
    action(TabEnum.about, this.about);
  }

  @override
  Iterable<TabEnum> get keys {
    return TabEnum.values;
  }

  @override
  Iterable<V> get values {
    return [
      this.books,
      this.about,
    ];
  }

  @override
  int get length {
    return 2;
  }

  @override
  bool get isEmpty {
    return false;
  }

  @override
  bool get isNotEmpty {
    return true;
  }

  V get(TabEnum key) {
    switch (key) {
      case TabEnum.books:
        return this.books;
      case TabEnum.about:
        return this.about;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer("{");
    buffer.write("TabEnum.books: ${this.books}");
    buffer.write(", ");
    buffer.write("TabEnum.about: ${this.about}");
    buffer.write("}");
    return buffer.toString();
  }
}
