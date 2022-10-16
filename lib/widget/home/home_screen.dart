import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/widget/community/community_screen.dart';
import 'package:frontend_flutter/widget/element/loading_overlay.dart';
import 'package:frontend_flutter/widget/setting/setting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(child: _HomeScreenContent());
  }
}

class _HomeScreenContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: menu(context),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            CommunityScreen(),
            SettingScreen()
          ],
        ),
      ),
    );
  }

  Widget menu(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(5.0),
        tabs: [
          const Tab(
            text: "Transactions",
            icon: Icon(Icons.euro_symbol),
          ),
          const Tab(
            text: "Bills",
            icon: Icon(Icons.assignment),
          ),
          Tab(
            text: AppLocalizations.of(context)!.homeScreen_tabCommunities,
            icon: const Icon(Icons.list),
          ),
          Tab(
            text: AppLocalizations.of(context)!.homeScreen_tabSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}