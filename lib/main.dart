import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/controllers/page_index_controller.dart';
import 'package:my_bank/controllers/user_controller.dart';
import 'package:my_bank/firebase_options.dart';
import 'package:my_bank/pages/card_details/card_details_page.dart';
import 'package:my_bank/pages/cards/cards_page.dart';
import 'package:my_bank/pages/history/history_page.dart';
import 'package:my_bank/pages/home.dart/home_page.dart';
import 'package:my_bank/pages/login/login_page..dart';
import 'package:my_bank/pages/profile/profile_page.dart';
import 'package:my_bank/widgets/tab_item.dart';


void main() async { //точка входу у програму
  WidgetsFlutterBinding.ensureInitialized(); //здійснює налаштування перед запуском додатку
  await Firebase.initializeApp( // ініціалізація firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final LockCartController cardController = Get.put(LockCartController());
   Get.put(UserController()); // інстанція до ініціалізованого контейнера залежностей GetX
  runApp(const MyApp()); // запускаємо інтерфейс
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, //вимикає банер з надписом "DEBUG" у верхньому правому куті додатку у відладковому режимі.
      title: 'My Bank',// це заголовок  додатку
      theme: ThemeData( // визначає тему вашого додатку,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(), //це сторінка, яка буде відображатися при запуску додатку
    );
  }
}


class MainPage extends StatelessWidget { //Головний еран в якому розміщено сторінки та навіація
  MainPage({Key? key}) : super(key: key);

  final List<Widget> pageList = [ //список сторінок
    HomePage(),
    HistoryPage(),
    CardsPage(),
    ProfilePage(),
  ];

 
  @override
  Widget build(BuildContext context) {
    final TabIndexController controller = Get.put(TabIndexController());
    return Obx(
      () => Scaffold(
        body: IndexedStack(//стек у якому будуть перемикатися сторінки
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
          child: BottomNavigationBar(// панкль наіації
            currentIndex: controller.tabIndex,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            type: BottomNavigationBarType.fixed,
            onTap: (value) => controller.tabIndex = value,
            items: [
              buildBottomNavigationBarItem("Головна", "assets/icons/home_page.png"),
              buildBottomNavigationBarItem("Історія", "assets/icons/clock_time.png"),
              buildBottomNavigationBarItem("Картка", "assets/icons/card.png"),
              buildBottomNavigationBarItem("Профіль", "assets/icons/user.png"),
            ],
          ),
        ),
      ),
    );
  }
}
