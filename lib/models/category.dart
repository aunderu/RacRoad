class Category {
  final int id;
  final String title;
  final String logo;

  Category(this.id, this.title, this.logo);
}

List<Category> categoryList = [
  Category(1, "BMW", "assets/imgs/logos/bmw.png"),
  Category(2, "Honda", "assets/imgs/logos/honda.png"),
  Category(3, "Izusu", "assets/imgs/logos/izusu.jpg"),
  Category(4, "Toyota", "assets/imgs/logos/toyota.jpg"),
  Category(5, "อื่น ๆ", "assets/imgs/logos/car_logo.jpg"),
];
