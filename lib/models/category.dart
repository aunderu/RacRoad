
class Category {
  final int id;
  final String title;
  final String logo;

  Category(this.id, this.title, this.logo);
}

List<Category> categoryList = [
  Category(1, "BMW", "assets/imgs/logos/bmw.png"),
  Category(2, "Honda", "assets/imgs/logos/honda.png"),
  Category(2, "Izusu", "assets/imgs/logos/izusu.jpg"),
  Category(3, "Toyota", "assets/imgs/logos/toyota.jpg"),
];
