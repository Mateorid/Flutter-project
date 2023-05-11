import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pet_sitting/pages/Ad/ads_page.dart';
import 'package:pet_sitting/pages/Pets/pets_page.dart';
import 'package:pet_sitting/pages/User/user_page.dart';
import 'package:pet_sitting/styles.dart';

import '../ioc_container.dart';
import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  final _authService = get<AuthService>();
  final _controller = PersistentTabController(initialIndex: 0);

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      AdsPage(),
      PetsPage(),
      UserPage(userId: _authService.currentUser!.uid), //todo better
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dashboard),
        title: ("Ads"),
        activeColorPrimary: MAIN_GREEN,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.pets),
        title: ("My Pets"),
        activeColorPrimary: MAIN_GREEN,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: ("Profile"),
        activeColorPrimary: MAIN_GREEN,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
