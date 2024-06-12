import 'package:al_khalil/app/pages/home/adminstration_page.dart';
import 'package:al_khalil/app/pages/home/drawer.dart';
import 'package:al_khalil/app/pages/home/dynamic_banner.dart';
import 'package:al_khalil/app/pages/home/my_groups_page.dart';
import 'package:al_khalil/app/pages/setting/setting_page.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/features/quran/pages/home_screen/quran_home_screen.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/messges/dialoge.dart';
import '../setting/change_password.dart';
import 'search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex =
      context.read<CoreProvider>().myAccount!.custom!.adder ? 1 : 0;

  Future<void> refreshMyAccount() async {
    await context.read<CoreProvider>().initialState().then((state) {
      if (state is DataState<Person>) {
        setState(() {
          context.read<CoreProvider>().myAccount = state.data;
        });
      }
      if (state is ErrorState) {
        CustomToast.handleError(state.failure);
      }
    });
  }

  // bool isOnline = true;
  final Connectivity connectivity = Connectivity();
  @override
  void initState() {
    Intl.defaultLocale = "ar";
    // connectivity.checkConnectivity().then((value) {
    //   if (value == ConnectivityResult.none) {
    //     isOnline = false;
    //   } else {
    //     isOnline = true;
    //   }
    // });

    // connectivity.onConnectivityChanged.listen((event) {
    //   if (event == ConnectivityResult.none) {
    //     isOnline = false;
    //   } else {
    //     isOnline = true;
    //   }
    //   setState(() {});
    // });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<CoreProvider>().initialState();
      if (context.read<CoreProvider>().myAccount!.password!.length < 5) {
        final agreed = await CustomDialog.showDeleteDialig(
          context,
          content: 'كلمة المرور ضعيفة جداً الرجاء تغييرها',
        );
        if (agreed && mounted) {
          context.myPush(ChangePasswordPage());
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        currentIndex: _currentIndex,
        onChange: (value) {
          if (value != 3) {
            setState(() {
              Navigator.of(context).pop();
              _currentIndex = value;
            });
          } else {
            context.myPush(const SettingPage());
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildSearchBar(),
            DynamicBanner(
              visable: false,
              color: Theme.of(context).colorScheme.error,
              text: "لايوجد إنترنت ",
              icon: Icons.wifi_off,
              onTap: () {},
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshMyAccount,
                child: Stack(
                  children: [
                    Offstage(
                      offstage: _currentIndex != 0,
                      child: const MyGroupsPage(),
                    ),
                    Offstage(
                      offstage: _currentIndex != 1,
                      child: const AdminstrationPage(),
                    ),
                    Offstage(
                      offstage: _currentIndex != 2,
                      child: const QuranHomeScreen(reason: PageState.nothing),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchBar() {
    final hint = switch (_currentIndex) {
      0 => "ابحث عن طالب",
      1 => "أدخل للبحث",
      2 => "ابحث عن اية",
      int() => "",
    };
    final title = switch (_currentIndex) {
      0 => "ابحث عن طالب",
      1 => "جامع إبراهيم الخليل",
      2 => "ابحث عن اية",
      int() => "",
    };
    final resaultBuilder = switch (_currentIndex) {
      0 => null,
      1 => null,
      2 => QuranHomeScreen.resualtBuilder,
      int() => null,
    };
    final onSearch = switch (_currentIndex) {
      0 => null,
      1 => null,
      2 => QuranHomeScreen.onSearch,
      int() => null,
    };
    final enable = switch (_currentIndex) {
      0 => false,
      1 => false,
      2 => true,
      int() => false,
    };
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomSearchBar(
        hint: hint,
        title: title,
        enable: enable,
        onSearch: onSearch,
        resultBuilder: resaultBuilder,
        showLeading: _currentIndex != 2,
      ),
    );
  }
}
