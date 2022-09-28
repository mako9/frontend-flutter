import 'package:flutter/material.dart';
import 'package:frontend_flutter/widget/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const route = '/';

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
              Icon(Icons.directions_bike),
              ProfileScreen()
            ],
          ),
        ),
      );
  }

  Widget menu(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: const TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        tabs: [
          Tab(
            text: "Transactions",
            icon: Icon(Icons.euro_symbol),
          ),
          Tab(
            text: "Bills",
            icon: Icon(Icons.assignment),
          ),
          Tab(
            text: "Balance",
            icon: Icon(Icons.account_balance_wallet),
          ),
          Tab(
            text: "Options",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}