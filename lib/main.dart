import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/firebase_options.dart';
import 'package:my_bank/pages/cards/cards_page.dart';
import 'package:my_bank/pages/history/history_page.dart';
import 'package:my_bank/pages/home.dart/home_page.dart';
import 'package:my_bank/pages/login/login_page..dart';
import 'package:my_bank/pages/login/sign_in_page.dart';
import 'package:my_bank/pages/profile/profile_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   Get.put(UserController());
  runApp(const MyApp());
}
class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  String userId = '';
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Bank',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class TabIndexController extends GetxController {
  final _tabIndex = 0.obs;

  int get tabIndex => _tabIndex.value;
  set tabIndex(int newValue) => _tabIndex.value = newValue;
}

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final List<Widget> pageList = [
    HomePage(),
    HistoryPage(),
    CardsPage(),
    ProfilePage(),
  ];

  BottomNavigationBarItem _buildBottomNavigationBarItem(String label, String iconPath) {
    return BottomNavigationBarItem(
      activeIcon: Image.asset(iconPath, width: 20, color: Colors.blueAccent),
      icon: Image.asset(iconPath, width: 20, color: Colors.grey),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TabIndexController controller = Get.put(TabIndexController());
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.tabIndex,
          children: pageList,
        ),
        bottomNavigationBar: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 8, blurRadius: 12, offset: Offset(0, -3), color: Color(0xfff4f4f4))
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.tabIndex,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            type: BottomNavigationBarType.fixed,
            onTap: (value) => controller.tabIndex = value,
            items: [
              _buildBottomNavigationBarItem("Головна", "assets/icons/home_page.png"),
              _buildBottomNavigationBarItem("Історія", "assets/icons/clock_time.png"),
              _buildBottomNavigationBarItem("Картка", "assets/icons/card.png"),
              _buildBottomNavigationBarItem("Профіль", "assets/icons/user.png"),
            ],
          ),
        ),
      ),
    );
  }
}
