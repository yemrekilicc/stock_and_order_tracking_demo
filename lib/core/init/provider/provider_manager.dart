import 'package:siparis_takip_demo/view/add_contact/viewmodel/add_contact_viewmodel.dart';
import 'package:siparis_takip_demo/view/admin_panel/viewmodel/admin_panel_viewmodel.dart';
import 'package:siparis_takip_demo/view/admin_panel_menu/viewmodel/admin_panel_menu_viewmodel.dart';
import 'package:siparis_takip_demo/view/contacts/viewmodel/contacts_viewmodel.dart';
import 'package:siparis_takip_demo/view/create_order/viewmodel/create_order_viewmodel.dart';
import 'package:siparis_takip_demo/view/orders/viewmodel/orders_viewmodel.dart';
import 'package:siparis_takip_demo/view/register/viewmodel/register_viewmodel.dart';
import 'package:siparis_takip_demo/view/statistics/viewmodel/statistics_viewmodel.dart';
import 'package:siparis_takip_demo/view/stock_add/viewmodel/stock_add_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../view/login/viewmodel/login_viewmodel.dart';
import '../../../view/main_screen/viewmodel/main_screen_viewmodel.dart';
import '../../../view/splash/viewmodel/splash_viewmodel.dart';
class ProviderManager {
  static ProviderManager? _instance;

  static ProviderManager get instance {
    _instance ??= ProviderManager._init();
    return _instance!;
  }

  ProviderManager._init();

  List<SingleChildWidget> singleProvider = [
    ///DEFAULT
    ChangeNotifierProvider<SplashViewModel>(
      create: (_) => SplashViewModel(),
    ),
    ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
    ),
    ChangeNotifierProvider<MainScreenViewModel>(
      create: (_) => MainScreenViewModel(),
    ),
    ChangeNotifierProvider<CreateOrderViewModel>(
      create: (_) => CreateOrderViewModel(),
    ),
    ChangeNotifierProvider<OrdersViewModel>(
      create: (_) => OrdersViewModel(),
    ),
    ChangeNotifierProvider<StatisticsViewModel>(
      create: (_) => StatisticsViewModel(),
    ),
    ChangeNotifierProvider<StockAddViewModel>(
      create: (_) => StockAddViewModel(),
    ),
    ChangeNotifierProvider<ContactsViewModel>(
      create: (_) => ContactsViewModel(),
    ),
    ChangeNotifierProvider<AddContactViewModel>(
      create: (_) => AddContactViewModel(),
    ),
    ChangeNotifierProvider<RegisterViewModel>(
      create: (_) => RegisterViewModel(),
    ),
    ChangeNotifierProvider<AdminPanelViewModel>(
      create: (_) => AdminPanelViewModel(),
    ),
    ChangeNotifierProvider<AdminPanelMenuViewModel>(
      create: (_) => AdminPanelMenuViewModel(),
    ),
  ];
}
