 import 'package:flutter/material.dart';

BottomNavigationBarItem buildBottomNavigationBarItem(String label, String iconPath) {
    return BottomNavigationBarItem(
      activeIcon: Image.asset(iconPath, width: 20, color: Colors.blueAccent),
      icon: Image.asset(iconPath, width: 20, color: Colors.grey),
      label: label,
    );
  }
