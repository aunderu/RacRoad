import 'package:flutter/material.dart';
import 'package:rac_road/models/menu_item.dart';

class MenuItems {
  static const List<CustomMenuItem> itemsFirst = [
    itemEdit,
  ];

  static const List<CustomMenuItem> itemsSecond = [
    itemDelete,
  ];

  static const itemEdit = CustomMenuItem(
    text: 'แก้ไข',
    icon: Icons.edit,
  );

  static const itemDelete = CustomMenuItem(
    text: 'ลบ',
    icon: Icons.group_off,
  );
}
