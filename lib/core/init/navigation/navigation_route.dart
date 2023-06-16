import 'package:siparis_takip_demo/view/add_contact/view/add_contact_view.dart';
import 'package:siparis_takip_demo/view/admin_panel/view/admin_panel_view.dart';
import 'package:siparis_takip_demo/view/admin_panel_menu/view/admin_panel_menu_view.dart';
import 'package:siparis_takip_demo/view/contacts/view/contacts_view.dart';
import 'package:siparis_takip_demo/view/create_order/view/create_order_view.dart';
import 'package:siparis_takip_demo/view/orders/view/orders_view.dart';
import 'package:siparis_takip_demo/view/register/view/register_view.dart';
import 'package:siparis_takip_demo/view/statistics/view/statistics_view.dart';
import 'package:siparis_takip_demo/view/stock_add/view/stock_add_view.dart';
import 'package:flutter/material.dart';
import '../../../view/login/view/login_view.dart';
import '../../../view/main_screen/view/main_screen_view.dart';
import '../../../view/splash/view/splash_view.dart';
import '../../constants/navigation_constant.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();

  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.DEFAULT:
        return noAnimatedNavigate(const SplashView(), NavigationConstants.DEFAULT);
      case NavigationConstants.LOGIN:
        return noAnimatedNavigate(const LoginView(), NavigationConstants.LOGIN);
      case NavigationConstants.MAINSCREEN:
        return noAnimatedNavigate(const MainScreenView(), NavigationConstants.MAINSCREEN,args: args.arguments);
      case NavigationConstants.CREATEORDER:
        return noAnimatedNavigate(const CreateOrderView(), NavigationConstants.CREATEORDER,args: args.arguments);
      case NavigationConstants.ORDERS:
        return noAnimatedNavigate(const OrdersView(), NavigationConstants.ORDERS);
      case NavigationConstants.STATISTICS:
        return noAnimatedNavigate(const StatisticsView(), NavigationConstants.STATISTICS);
      case NavigationConstants.STOCKADD:
        return noAnimatedNavigate(const StockAddView(), NavigationConstants.STOCKADD);
      case NavigationConstants.CONTACTS:
        return noAnimatedNavigate(const ContactsView(), NavigationConstants.CONTACTS);
      case NavigationConstants.ADDCONTACT:
        return noAnimatedNavigate(const AddContactView(), NavigationConstants.ADDCONTACT,args: args.arguments);
      case NavigationConstants.REGISTER:
        return noAnimatedNavigate(const RegisterView(), NavigationConstants.REGISTER);
      case NavigationConstants.ADMINPANEL:
        return noAnimatedNavigate(const AdminPanelView(), NavigationConstants.ADMINPANEL,args: args.arguments);
      case NavigationConstants.ADMINPANELMENU:
        return noAnimatedNavigate(const AdminPanelMenuView(), NavigationConstants.ADMINPANELMENU);
      default:
        return MaterialPageRoute(
          builder: (context) => const Text("Böyle Bir Sayfa Yok"),
        );
    }
  }

  MaterialPageRoute normalNavigate(Widget widget, String pageName,{Object? args}) {
    return MaterialPageRoute(
      builder: (context) => widget,
      //analytciste görülecek olan sayfa ismi için pageName veriyoruz
      settings: RouteSettings(name: pageName,arguments: args),
    );
  }

  PageRouteBuilder animatedNavigate(Widget widget, String pageName) {
    return PageRouteBuilder(
      settings: RouteSettings(name: pageName),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation1, animation2) => widget,
      transitionsBuilder: (context, animation1, animation2, child) {
        return FadeTransition(opacity: animation1, child: child);
      },
    );
  }

  PageRouteBuilder noAnimatedNavigate(Widget widget, String pageName,{Object? args}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: pageName,arguments: args),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation1, animation2) => widget,
    );
  }
}
