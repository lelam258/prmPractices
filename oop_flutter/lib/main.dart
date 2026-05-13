// Lớp cha (Parent class)
class Animal {
  String name;
  int age;

  // Constructor
  Animal(this.name, this.age);

  // Method
  void speak() {
    print('$name is making a sound');
  }
}

// Lớp con (Child class) kế thừa từ Animal
class Dog extends Animal {
  String breed;

  // Constructor gọi constructor của lớp cha
  Dog(String name, int age, this.breed) : super(name, age);

  // Override method
  @override
  void speak() {
    print('$name is barking');
  }

  // Method riêng của Dog
  void showInfo() {
    print('Name: $name, Age: $age, Breed: $breed');
  }
}

void main() {
  // Tạo object
  Dog dog1 = Dog('Buddy', 3, 'Golden Retriever');

  // Gọi method
  dog1.speak();
  dog1.showInfo();
}