import 'dart:async';

import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/pages/admincartspage.dart';
import 'package:flowerbasket/pages/admincategoriespage.dart';
import 'package:flowerbasket/pages/admincommentspage.dart';
import 'package:flowerbasket/pages/adminimagespage.dart';
import 'package:flowerbasket/pages/adminloginpage.dart';
import 'package:flowerbasket/pages/adminmessagespage.dart';
import 'package:flowerbasket/pages/adminorderspage.dart';
import 'package:flowerbasket/pages/adminsellerspage.dart';
import 'package:flowerbasket/pages/adminstatuspage.dart';
import 'package:flowerbasket/pages/commentspage.dart';
import 'package:flowerbasket/pages/sellerhome.dart';
import 'package:flowerbasket/pages/sellerproductadd.dart';
import 'package:flowerbasket/pages/sellerproductedit.dart';
import 'package:flowerbasket/pages/sellerprofile.dart';
import 'package:flowerbasket/pages/sellerregister.dart';
import 'package:flowerbasket/pages/useraddress.dart';
import 'package:flowerbasket/pages/userlogin.dart';
import 'package:flowerbasket/pages/userpaymentpage.dart';
import 'package:flowerbasket/pages/userregiser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'pages/adminhome.dart';
import 'pages/adminproductspage.dart';
import 'pages/adminusers.dart';
import 'pages/changepassword.dart';
import 'pages/forgetpage.dart';
import 'pages/productdetailpage.dart';
import 'pages/sellerdetail.dart';
import 'pages/useraddaddress.dart';
import 'pages/useraddressconfirm.dart';
import 'pages/userorderspage.dart';
import 'pages/userpage.dart';
import 'pages/userprofile.dart';
import 'pages/usertype.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await inital();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

bool noConnection = false;

Future<void> inital() async {
  await GetStorage.init().then((value) async {
    if (BoxData.read("token") != null) {
      var result = await sendGet("/all/check");
      if (result.statusCode == 200) {
        var type = parseType(result.bodyBytes);
        if (type.isSeller == true) {
          BoxData.write("type", "seller");
          BoxData.write("sub", type.id);
          BoxData.write("name", type.username);
        } else if (type.isSeller == false) {
          BoxData.write("type", "user");
          BoxData.write("sub", type.id);
          BoxData.write("name", type.username);
        } else {
          BoxData.erase();
        }
      } else if (result.statusCode == 503) {
        noConnection = true;
      } else {
        BoxData.erase();
      }
    }
  });
}

// ignore: non_constant_identifier_names
final BoxData = GetStorage();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MyColors.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: MyColors.secondary,
        ),
        scaffoldBackgroundColor: MyColors.back,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: MyColors.secondary,
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        useMaterial3: true,
      ),

      getPages: [
        GetPage(
          name: "/main",
          page: () {
            if (noConnection == true) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Failed to connect to server",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            } else if (BoxData.read("token") != null) {
              if (BoxData.read("type") == "user") {
                return const Home();
              } else if (BoxData.read("type") == "seller") {
                return const SellerHome();
              } else {
                return const UserType();
              }
            } else {
              return const UserType();
            }
          },
        ),
        GetPage(
            name: "/userhome",
            page: () => const Home(),
            transition: Transition.fadeIn),
        GetPage(name: "/type", page: () => const UserType()),
        GetPage(
            name: "/userlogin",
            page: () => const UserLogin(type: "user"),
            transition: Transition.rightToLeft),
        GetPage(
            name: "/userregister",
            page: () => const UserRegister(),
            transition: Transition.rightToLeftWithFade),
        GetPage(name: "/useraddress", page: () => const UserAddress()),
        GetPage(
            name: "/userforgot",
            page: () => const ForgetPage(type: "user"),
            transition: Transition.rightToLeftWithFade),
        GetPage(
            name: "/useraddaddress",
            page: () => const AddAddress(),
            transition: Transition.zoom),
        GetPage(
            name: "/useraddressconfirm",
            page: () => const AddressConfirm(),
            transition: Transition.zoom),
        GetPage(
            name: "/userprofile",
            page: () => const UserProfile(),
            transition: Transition.zoom),
        GetPage(
            name: "/userchange",
            page: () => const ChangePassword(type: "user"),
            transition: Transition.zoom),
        GetPage(
            name: "/userorders",
            page: () => const UserOrders(),
            transition: Transition.zoom),
        GetPage(name: "/sellerdetail", page: () => const SellerDetail()),
        GetPage(
            name: "/product",
            page: () => const ProductDetail(),
            transition: Transition.zoom),
        GetPage(
            name: "/comments",
            page: () => const CommentsPage(),
            transition: Transition.zoom),
        GetPage(
            name: "/userpayment",
            page: () => const PaymentPage(),
            transition: Transition.zoom),
        GetPage(
            name: "/sellerlogin",
            page: () => const UserLogin(type: "seller"),
            transition: Transition.rightToLeft),
        GetPage(
            name: "/sellerregister",
            page: () => const SellerRegister(),
            transition: Transition.rightToLeftWithFade),
        GetPage(
            name: "/sellerforgot",
            page: () => const ForgetPage(type: "seller"),
            transition: Transition.rightToLeftWithFade),
        GetPage(
            name: "/sellerhome",
            page: () => const SellerHome(),
            transition: Transition.zoom),
        GetPage(
            name: "/sellerproductedit",
            page: () => const EditProduct(),
            transition: Transition.zoom),
        GetPage(
            name: "/sellerchange",
            page: () => const ChangePassword(type: "seller"),
            transition: Transition.zoom),
        GetPage(
            name: "/sellerproductadd",
            page: () => const AddProduct(),
            transition: Transition.zoom),
        GetPage(
          name: "/sellerprofile",
          page: () => const SellerProfilePage(),
          transition: Transition.zoom,
        ),
        GetPage(
            name: "/adminlogin",
            page: () => const AdminLogin(),
            transition: Transition.rightToLeft),
        GetPage(
            name: "/adminhome",
            page: () => const AdminHome(),
            transition: Transition.zoom),
        GetPage(
            name: "/adminusers",
            page: () => const AdminUsers(),
            transition: Transition.downToUp),
        GetPage(
            name: "/adminsellers",
            page: () => const AdminSellers(),
            transition: Transition.downToUp),
        GetPage(
            name: "/adminproducts",
            page: () => const AdminProducts(),
            transition: Transition.downToUp),
        GetPage(
            name: "/adminorders",
            page: () => const AdminOrders(),
            transition: Transition.downToUp),
        GetPage(
            name: "/admincategories",
            page: () => const AdminCatagories(),
            transition: Transition.downToUp),
        GetPage(
            name: "/adminmessages",
            page: () => const AdminMessages(),
            transition: Transition.downToUp),
        GetPage(
            name: "/admincomments",
            page: () => const AdminComments(),
            transition: Transition.downToUp),
        GetPage(
            name: "/adminimages",
            page: () => const AdminImages(),
            transition: Transition.downToUp),
        GetPage(
            name: "/admincarts",
            page: () => const AdminCarts(),
            transition: Transition.downToUp),
        GetPage(
            name: "/adminstatus",
            page: () => const AdminStatus(),
            transition: Transition.downToUp),
      ],
      initialRoute: '/main',
      // home: UserType(),
    );
  }
}
