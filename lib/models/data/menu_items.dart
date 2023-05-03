import 'package:flutter/material.dart';
import 'package:rac_road/models/menu_item.dart';

class CarMenuItems {
  static const itemDelete = CustomMenuItem(
    text: 'ลบข้อมูลรถ',
    icon: Icons.car_crash_outlined,
  );

  static const List<CustomMenuItem> itemsDelete = [
    itemDelete,
  ];
}

class ClubMenuItems {
  static const itemDelete = CustomMenuItem(
    text: 'ลบคลับ',
    icon: Icons.group_off,
  );

  static const itemEdit = CustomMenuItem(
    text: 'แก้ไขคลับ',
    icon: Icons.edit,
  );

  static const List<CustomMenuItem> itemsFirst = [
    itemEdit,
  ];

  static const List<CustomMenuItem> itemsSecond = [
    itemDelete,
  ];
}

class JobMenuItems {
  static const itemDelete = CustomMenuItem(
    text: 'ลบช่าง',
    icon: Icons.group_off,
  );

  // static const itemEdit = CustomMenuItem(
  //   text: 'แก้ไขข้อมูลช่าง',
  //   icon: Icons.edit,
  // );

  // static const List<CustomMenuItem> itemsFirst = [
  //   itemEdit,
  // ];

  static const List<CustomMenuItem> itemsFirst = [
    itemDelete,
  ];
}

class ClubDetailMenuItem {
  static const itemLeave = CustomMenuItem(
    text: 'ออกจากคลับ',
    icon: Icons.exit_to_app,
  );

  static const List<CustomMenuItem> itemsFirst = [
    itemLeave,
  ];
}
