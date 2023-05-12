import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/handle_async_operation.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:pet_sitting/services/image_service.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/icon_text_button.dart';
import 'package:pet_sitting/widgets/user/profile_widget.dart';
import 'package:pet_sitting/widgets/widget_future_builder.dart';

class ProfilePage extends StatelessWidget {
  final _img = const NetworkImage(
      'https://thumbs.dreamstime.com/b/internet-connection-outer-space-concept-via-satellite-communication-47542605.jpg');
  final String userId;
  final _userService = get<UserService>();
  final _authService = get<AuthService>();
  final _imageService = get<ImageService>();

  ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetFutureBuilder(
        future: _userService.getUserById(userId),
        onLoaded: (user) => _buildContent(context, user),
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserExtended user) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 60),
        ProfileWidget(
          image: _imageService.getUserImage(user),
          onTap: () => {context.pushNamed('edit_user')},
        ),
        _buildName(user),
        const Spacer(),
        _buildLogoutButton(context)
      ],
    );
  }

  Widget _buildName(UserExtended user) {
    return Column(
      //todo colors
      children: [
        Text(
          user.name ?? user.email,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            // color: DARK_GREEN,
          ),
        ),
        user.name != null
            ? Text(user.email,
                style: const TextStyle(
                  // color: MAIN_GREEN,
                  color: Colors.black54,
                  fontSize: 15,
                ))
            : const SizedBox.shrink()
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: IconTextButton(
          text: 'Logout',
          onPressed: () => _onLogoutPressed(context),
          icon: Icons.exit_to_app_rounded,
        ),
      ),
    );
  }

  void _onLogoutPressed(BuildContext context) async {
    await handleAsyncOperation(
        asyncOperation: _authService.signOut(),
        onSuccessText: 'Sign out successful',
        context: context);

    if (context.mounted) {
      context.go('/login');
    }
  }
}
