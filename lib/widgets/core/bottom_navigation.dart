import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/ChangeNotifier/navbar_index.dart';
import 'package:pet_sitting/styles.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class BottomNavigation extends StatelessWidget {
  final _authService = GetIt.I<AuthService>();

  BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavbarIndex>(builder: (context, navbarIndex, _) {
      return BottomNavigationBar(
        currentIndex: navbarIndex.index,
        onTap: (int index) => onTap(index, context),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Ads',
            backgroundColor: MAIN_GREEN,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pets',
            backgroundColor: MAIN_GREEN,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind),
            label: 'Profile',
            backgroundColor: MAIN_GREEN,
          ),
        ],
      );
    });
  }

  void onTap(int index, BuildContext context){
    final navbarIndex = Provider.of<NavbarIndex>(context, listen: false);
    if (index == navbarIndex.index ) {
      return;
    }
    navbarIndex.index = index;
    if (index == 0){
      context.goNamed("ads");
    }
    if (index == 2){
      context.pushNamed("user_details", params: {
        "id": _authService.currentUserId!,
        "isDetail": false.toString(),
      });
    }

  }

}
