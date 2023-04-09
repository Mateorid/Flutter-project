import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/pages/home_page.dart';
import 'package:pet_sitting/pages/login_page.dart';
import 'package:pet_sitting/pages/register_page.dart';


class RouterProvider {
  static GoRouter provideRouter() {
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: "/login",
      routes: [
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
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
  }
}
