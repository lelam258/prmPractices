import 'package:flutter/material.dart';

void main(){
  exercise1();
  exercise2();
  exercise3();
  exercise4();
  exercise5();
}

void exercise1(){
  print("Exercise 1:");
  int numberA = 1;
  double numberB = 3.14;
  String name = "Lam";
  bool isMale = true;
  print("Hello $name");
  print("Name length: ${name.length}");
}

void exercise2(){
  print("Exercise 2:");
  List<int> numList = [1,5,6,10,40];
  print(numList[1]+ numList[4]);
  print(numList[0]<numList[2] && numList[4]<numList[3]);
  Set<int> numSet = {1,1,4,7,9,190,34};
  Map<int, String> stringMap = {
    1: "Lam",
    2: "Binh",
    3: "Minh"
  };
  print("Original List:");
  numList.forEach((n) => print("$n "));
  print("Original Set:");
  print(numSet);
  print("Original Map:");
  print(stringMap);
  numList.add(10);
  numSet.remove(1);
  print("New List:");
  print(numList);
  print("New Set:");
  print(numSet);
  print("Map[2]");
  print(stringMap[2]);
}

void exercise3(){
  print("Exercise 3:");
  int num1 = 3;
  if (num1 > 0) print("$num is larger than 0");
  else print("$num is smaller than 0");
  switch(num1){
    case 1: print("Hi"); break;
    case 2: print("Goodbye"); break;
    default: print("Welcome"); break;
  }
  for (int i=1; i<=num1; i++) print(i);
  List<int> numList = [1,5,6,10,40];
  for (var num in numList) {
    print(num);
  }
}
void arrowSyntaxFunction() => print("This is a arrow Syntax Function");

void exercise4() {
  print("Exercise 4:");
  Car car1 = new Car("Sound1");
  ElectricCar car2 = new ElectricCar("Sound2");
  car1.playSound();
  car2.playSound();
}
class Car{
  String sound;
  Car(this.sound);
  void playSound() => print("$sound is playing");
}
class ElectricCar extends Car{
  ElectricCar(super.sound);
  @override void playSound() => print("Playing $sound");
}

void exercise5() async{
  print("Exercise 5:");
  String? name = await fetchUsername(2);
  String displayName = name ?? 'NoName';
  print('Xin chào: $displayName');
}

Future<String?> fetchUsername(int id) async {
  print('Loading...');
  await Future.delayed(Duration(seconds: 2));
  if (id == 1) return 'Adam';
  return null;
}