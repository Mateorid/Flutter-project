import 'package:go_router/go_router.dart';
import 'package:pet_sitting/pages/Ad/ad_detail_page.dart';
import 'package:pet_sitting/pages/Ad/ads_page.dart';
import 'package:pet_sitting/pages/Ad/create_edit_ad.dart';
import 'package:pet_sitting/pages/Pets/create_edit_pet.dart';
import 'package:pet_sitting/pages/Pets/pet_profile_page.dart';
import 'package:pet_sitting/pages/Pets/pets_page.dart';
import 'package:pet_sitting/pages/User/edit_user_page.dart';
import 'package:pet_sitting/pages/User/profile_page.dart';
import 'package:pet_sitting/pages/User/upload_file_page.dart';
import 'package:pet_sitting/pages/User/user_page.dart';
import 'package:pet_sitting/pages/home_page.dart';
import 'package:pet_sitting/pages/login_page.dart';
import 'package:pet_sitting/pages/register_page.dart';
import 'package:pet_sitting/services/auth_service.dart';

import 'Models/Pet/pet.dart';
import 'ioc_container.dart';

class RouterProvider {
  static GoRouter provideRouter() {
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: get<AuthService>().currentUser != null ? "/" : "/login",
      routes: [
        GoRoute(
          path: "/edit_user",
          name: "edit_user",
          builder: (context, state) => EditUserPage(),
        ),
        GoRoute(
          path: "/user_details/:id",
          name: "user_details",
          builder: (context, state) => UserPage(userId: state.params["id"]!),
        ),
        GoRoute(
          path: "/user_profile/:id",
          name: "user_profile",
          builder: (context, state) => ProfilePage(userId: state.params["id"]!),
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
          builder: (context, state) => CreateEditPet(),
        ),
        GoRoute(
          path: "/edit_pet/:id",
          name: "edit_pet",
          builder: (context, state) => CreateEditPet(
            petId: state.params["id"]!,
          ),
        ),
        GoRoute(
          path: "/pet_profile",
          name: "pet_profile",
          builder: (context, state) {
            Pet pet = state.extra as Pet;
            return PetProfilePage(pet: pet);
          },
        ),
        GoRoute(
          path: "/create_ad",
          name: "create_add",
          builder: (context, state) => CreateEditAdPage(),
        ),
        GoRoute(
          path: "/ads",
          name: "ads",
          builder: (context, state) => AdsPage(),
        ),
        GoRoute(
          path: "/upload/:id",
          name: "upload",
          builder: (context, state) {
            return UploadFilePage(
              id: state.params["id"]!,
            );
          },
        ),
        GoRoute(
          path: "/ad_detail/:id",
          name: "ad_details",
          builder: (context, state) {
            return AdDetailPage(
              adId: state.params["id"]!,
            );
          },
        ),
        GoRoute(
          path: "/ad_edit/:id",
          name: "ad_edit",
          builder: (context, state) {
            return CreateEditAdPage(
              adId: state.params["id"]!,
            );
          },
        ),
        GoRoute(
          path: "/pest",
          name: "pets",
          builder: (context, state) {
            return PetsPage();
          },
        ),
      ],
    );
  }
}
