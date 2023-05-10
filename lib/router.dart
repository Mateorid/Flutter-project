import 'package:go_router/go_router.dart';
import 'package:pet_sitting/pages/edit_pet_page.dart';
import 'package:pet_sitting/pages/edit_user_page.dart';
import 'package:pet_sitting/pages/home_page.dart';
import 'package:pet_sitting/pages/login_page.dart';
import 'package:pet_sitting/pages/pet_profile_page.dart';
import 'package:pet_sitting/pages/register_page.dart';
import 'package:pet_sitting/services/auth_service.dart';

import 'Models/Pet/pet.dart';
import 'ioc_container.dart';

class RouterProvider {
  static GoRouter provideRouter() {
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: get<AuthService>().currentUser != null ? "/" : "/login",
      // initialLocation: "/",
      routes: [
        GoRoute(
          path: "/edit_user",
          name: "edit_user",
          builder: (context, state) => EditUserPage(),
        ),
        GoRoute(
          path: "/login",
          name: "login",
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: "/register",
          name: "register",
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: "/",
          name: "home",
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: "/create_pet",
          name: "create_pet",
          // builder: (context, state) => AddPetPage(),
          builder: (context, state) => EditPetPage(),
        ),
        GoRoute(
          path: "/pet_profile",
          name: "pet_profile",
          builder: (context, state) {
            Pet pet = state.extra as Pet;
            return PetProfilePage(pet: pet);
          },
        )
      ],
    );
  }
}
