class Category {
  Category(this.id, this.title, this.logo);

  final int id;
  final String logo;
  final String title;
}

List<Category> categoryList = [
  Category(1, "กลุ่มพูดคุย", "assets/imgs/logos/bmw.png"),
  Category(2, "ชื่อขาย", "assets/imgs/logos/honda.png"),
  Category(3, "แลกเปลี่ยนข้อมูล", "assets/imgs/logos/izusu.jpg"),
  Category(4, "อื่น ๆ", "assets/imgs/logos/car_logo.jpg"),
];