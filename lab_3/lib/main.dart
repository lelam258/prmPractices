import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

void main() async{
  ex1();
  await Future.delayed(Duration(seconds: 10));
  ex2();
  await Future.delayed(Duration(seconds: 10));
  ex3();
  await Future.delayed(Duration(seconds: 10));
  ex4();
  await Future.delayed(Duration(seconds: 10));
  ex5();
}

void ex1() async{
  List<Product> newProducts = [
      Product(id: '3', name: 'Keyboard', price: 299.99),
      Product(id: '4', name: 'Headphone', price: 199.99),
  ];
  print("Ex1:");
  final repo = ProductRepository();
  repo.liveAdded().listen(
    (newProduct){
        print('New product found: $newProduct');
    }
  );
  print('Original list:');
  final originalProducts = await repo.getAll();
  for (var p in originalProducts) print('$p');
  print('New products:');
  await Future.delayed(Duration(seconds: 1));
  for (var p in newProducts) repo.addProduct(p);
  await Future.delayed(Duration(seconds: 1));
  repo.dispose();
}
class Product {
  final String id;
  final String name;
  final double price;
  Product({required this.id, required this.name, required this.price});
  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}
class ProductRepository {
  final List<Product> _products = [
      Product(id: '1', name: 'Laptop Dell', price: 999.99),
      Product(id: '2', name: 'iPhone 15', price: 799.99),
    ];
  Future<List<Product>> getAll() async {
      await Future.delayed(Duration(seconds: 1));
      return List.from(_products);
  }
  final StreamController<Product> _productController = StreamController<Product>.broadcast();
  Stream<Product> liveAdded() {
    return _productController.stream;
  }
  void addProduct(Product pro){
    _products.add(pro);
    _productController.add(pro);
  }
  void dispose(){
    _productController.close();
  }
}

void ex2() async{
  print("Ex2:");
  try {
    List<User> userList = await fetchAndParseUsers();
    print('Found ${userList.length} user(s)\n');
    for (var user in userList) {
      print('$user');
    }
  } catch (e) {
    print('Error: $e');
  }
}
class User{
  final String name;
  final String email;
  User({required this.name, required this.email});
  @override
  String toString() => 'User(name: $name, email: $email)';
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
String simulateApiResponse() {
  return '''
  [
    {"name": "Nguyen Van A", "email": "vana@gmail.com"},
    {"name": "Tran Thi B", "email": "thib@gmail.com"},
    {"name": "Le Van C", "email": "vanc@gmail.com"}
  ]
  ''';
}
Future<List<User>> fetchAndParseUsers() async {
  await Future.delayed(Duration(seconds: 1));
  String rawJsonString = simulateApiResponse();
  final List<dynamic> decodedList = jsonDecode(rawJsonString);
  List<User> users = decodedList.map((item) {
    return User.fromJson(item as Map<String, dynamic>);
  }).toList();
  return users;
}
void ex3(){
  print("Ex3:");
  print('1. Starting Synchronous');
  Future(() {
    print('5. Future');
  });
  scheduleMicrotask(() {
    print('3. Start 1st microtask');
  });
  scheduleMicrotask(() {
    print('4. Start 2nd microtask');
  });
  Future.value().then((_) {
    print('4.5. Callback of Future.value().then');
  });
  print('2. Ending Synchronous');
}

void ex4(){
  print("Ex4:");
  Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);
  Stream<int> squaredStream = numberStream.map((number) {
    return number * number;
  });
  Stream<int> evenSquaredStream = squaredStream.where((squaredNumber) {
    return squaredNumber % 2 == 0;
  });
  print('Result from Stream:');

  evenSquaredStream.listen(
        (finalResult) {
      print('Emitted value : $finalResult');
    },
    onDone: () {
      print('--- Ending Stream ---');
    },
  );
}

void ex5(){
  print("Ex5:");
  print('Call Settings() - 1st try:');
  Settings a = Settings();

  print('\nCall Settings() - 2nd try:');
  Settings b = Settings();
  print('\n--- Verification ---');

  bool isSameObject = identical(a, b);
  print('Identical(a, b): $isSameObject');
  print('\n--- Altering data ---');
  a.theme = 'dark';
  print('Theme setting a: ${a.theme}');
  print('Theme setting b: ${b.theme}');
}
class Settings {
  String theme;
  bool notificationsEnabled;

  static Settings? _instance;
  Settings._internal({required this.theme, required this.notificationsEnabled});

  factory Settings() {
    if (_instance == null) {
      print('-> Null cache');
      _instance = Settings._internal(theme: 'light', notificationsEnabled: true);
    } else {
      print('-> Found instance');
    }
    return _instance!;
  }
}