import 'package:al_khalil/app/pages/home/adminstration_page.dart';
import 'package:al_khalil/app/pages/home/drawer.dart';
import 'package:al_khalil/app/pages/home/dynamic_banner.dart';
import 'package:al_khalil/app/pages/home/my_groups_page.dart';
import 'package:al_khalil/app/pages/setting/setting_page.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/features/quran/pages/home_screen/quran_home_screen.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late final myAccount = context.read<CoreProvider>().myAccount;
  late int _currentIndex = myAccount!.custom!.isAdminstration ? 1 : 0;
  bool isOnline = true;
  final NetworkInfoImpl connectivity = NetworkInfoImpl();

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

  @override
  void initState() {
    connectivity.connectivityStream((event) => setState(() {
          isOnline = event;
        }));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await refreshMyAccount();
      if (mounted) {
        if (context.read<CoreProvider>().myAccount!.password!.length < 5) {
          final agreed = await CustomDialog.showDeleteDialig(
            context,
            content: 'كلمة المرور ضعيفة جداً الرجاء تغييرها',
          );
          if (agreed && mounted) {
            context.myPush(ChangePasswordPage());
          }
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
          if (value == 3) {
            Navigator.of(context).pop();

            context.myPush(QuranHomeScreen(
              reason: PageState.view,
              student: myAccount,
            ));
          } else if (value == 4) {
            Navigator.of(context).pop();

            context.myPush(const SettingPage());
          } else {
            Navigator.of(context).pop();
            _currentIndex = value;
            setState(() {});
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
            if (context.watch<CoreProvider>().isLoggingIn != null)
              const LinearProgressIndicator(),
            DynamicBanner(
              color: Theme.of(context).colorScheme.error,
              visable: !isOnline,
              text: OfflineFailure.error,
              icon: CupertinoIcons.wifi_exclamationmark,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshMyAccount,
                child: Stack(
                  children: [
                    if (_currentIndex == 0) const MyGroupsPage(),
                    if (_currentIndex == 1) const AdminstrationPage(),
                    if (_currentIndex == 2)
                      const QuranHomeScreen(reason: PageState.nothing),
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
