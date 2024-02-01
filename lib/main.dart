import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/firebase_options.dart';
import 'package:my_bank/pages/history/history_page.dart';
import 'package:my_bank/pages/home_page.dart/home_page.dart';
import 'package:my_bank/pages/login/login_page..dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Bank',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginPage(),
    );
  }
}
class TabIndexController extends GetxController {
  RxInt _tabIndex = 0.obs; 

  int get tabIndex => _tabIndex.value;

  set setTabIndex(int newValue){
    _tabIndex.value = newValue;
  }

}
class MainPage extends StatelessWidget {
   MainPage({super.key});
  List <Widget>pageList = [
    HomePage(),
    HistoryPage(),
    Scaffold(),
    Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabIndexController());
    return Obx(() => Scaffold(
                body: IndexedStack(
                index: controller.tabIndex,
                children: pageList,
              ),
                bottomNavigationBar: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                        spreadRadius: 8,
                        blurRadius: 12,
                        offset: Offset(0, -3),
                        color: Color(0xfff4f4f4))
                  ], ),
                 
                  child: BottomNavigationBar(
                     currentIndex: controller.tabIndex,
                    showUnselectedLabels: false,
                    showSelectedLabels: false,
                 
                    type: BottomNavigationBarType.fixed,
                    onTap: (value) {
                      controller.setTabIndex = value;
                    },
                   
                    items: [
                      BottomNavigationBarItem(
                        activeIcon: Image.asset(
                                  "assets/icons/home_page.png",
                                  width: 20,
                                  color: Colors.blueAccent,
                                ),
                          icon: Image.asset(
                                  "assets/icons/home_page.png",
                                  width: 20,
                                   color: Colors.grey,
                                ),
                          label: "Головна"),
                      BottomNavigationBarItem(
                          activeIcon: Image.asset(
                                  "assets/icons/clock_time.png",
                                  width: 20,
                                  color: Colors.blueAccent,
                                ),
                          icon: Image.asset(
                                  "assets/icons/clock_time.png",
                                  width: 20,
                                   color: Colors.grey,
                                ),
                          label: "Історія"),
                           BottomNavigationBarItem(
                             activeIcon: Image.asset(
                                  "assets/icons/card.png",
                                  width: 20,
                                  color: Colors.blueAccent,
                                ),
                          icon: Image.asset(
                                  "assets/icons/card.png",
                                  width: 20,
                                   color: Colors.grey,
                                ),
                          label: "Картка"),
                           BottomNavigationBarItem(
                              activeIcon: Image.asset(
                                  "assets/icons/user.png",
                                  width: 20,
                                  color: Colors.blueAccent,
                                ),
                          icon: Image.asset(
                                  "assets/icons/user.png",
                                  width: 20,
                                   color: Colors.grey,
                                ),
                          label: "Профіль"),
                    ],
                  ),
                ),
              )
      
    );
  }
}



