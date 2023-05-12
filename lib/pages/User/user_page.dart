import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/pages/page_template.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/icon_text_button.dart';
import 'package:pet_sitting/widgets/user/rating_bard.dart';
import 'package:pet_sitting/widgets/user/user_info_field.dart';
import 'package:pet_sitting/widgets/user/user_round_image.dart';
import 'package:pet_sitting/widgets/widget_future_builder.dart';

import '../../Models/User/user_extended.dart';
import '../../handle_async_operation.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class UserPage extends StatelessWidget {
  final String userId;
  late UserExtended user;

  UserPage({Key? key, required this.userId}) : super(key: key);

  final _userService = get<UserService>();
  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTemplate(
        pageTitle: 'User profile',
        body: WidgetFutureBuilder(
          future: _userService.getUserById(userId),
          onLoaded: (usr) {
            user = usr;
            return _buildContent(context);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserInfo(context),
        const Divider(thickness: 2),
        _buildDetailedInfo(),
        const Spacer(),
        if (userId == _authService.currentUserId) _buildLogoutButton(context),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildImage(),
          const SizedBox(height: 10),
          _buildName(),
          RatingBar(rating: 3.2, ratingCount: 10),
          if (userId == _authService.currentUserId) _buildEditButton(context),
        ],
      ),
    );
  }

  Widget _buildDetailedInfo() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoField(icon: Icons.email, text: user.email),
            if (user.phoneNumber != null)
              UserInfoField(icon: Icons.phone, text: user.phoneNumber!),
            if (user.location != null)
              UserInfoField(icon: Icons.location_on, text: user.location!),
            const SizedBox(height: 10),
            if (user.aboutMe != null) _buildAboutMe(),
          ],
        ));
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

  Widget _buildEditButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: IconTextButton(
          text: 'Edit profile',
          onPressed: () => {context.pushNamed('edit_user')},
          icon: Icons.settings,
        ),
      ),
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

  Widget _buildName() {
    return Text(
      user.name ?? user.email,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: DARK_GREEN,
      ),
    );
  }

  Widget _buildImage() {
    return UserRoundImage(size: 130, url: user.imageUrl);
  }

  Widget _buildAboutMe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: DARK_GREEN,
          ),
        ),
        Text(
          user.aboutMe!,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 18),
          maxLines: null,
        )
      ],
    );
  }
}
