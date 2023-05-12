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
import 'package:pet_sitting/widgets/core/outlined_container.dart';
import 'package:pet_sitting/widgets/user/profile_widget.dart';
import 'package:pet_sitting/widgets/user/rating_bard.dart';
import 'package:pet_sitting/widgets/user/user_info_field.dart';
import 'package:pet_sitting/widgets/widget_future_builder.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  final _userService = get<UserService>();
  final _authService = get<AuthService>();
  final _imageService = get<ImageService>();
  static const _padding = 50.0;

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
    return Stack(children: [
      ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 25),
          ProfileWidget(
            image: _imageService.getUserImage(user),
            onTap: () => {context.pushNamed('edit_user')},
          ),
          _buildNameOrEmail(user),
//todo interactive ratings
          Center(child: RatingBar(rating: 4.6, ratingCount: 69, size: 30)),
          const SizedBox(height: 15),
          Center(child: _buildContactInformation(context, user)),
        ],
      ),
      Positioned(
        bottom: 20,
        width: MediaQuery.of(context).size.width,
        child: Center(child: _buildLogoutButton(context)),
      )
    ]);
  }

  Widget _buildNameOrEmail(UserExtended user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          user.name ?? user.email,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
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

  Widget _buildContactInformation(BuildContext context, UserExtended user) {
    if (user.name == null &&
        user.location == null &&
        user.phoneNumber == null &&
        user.aboutMe == null) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Divider(
          thickness: 3,
          indent: _padding,
          endIndent: _padding,
          color: MAIN_GREEN,
        ),
        if (user.location != null)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: UserInfoField(
              icon: Icons.location_on,
              text: user.location!,
              lPadding: _padding,
            ),
          ),
        if (user.name != null)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: UserInfoField(
              icon: Icons.email_outlined,
              text: user.email,
              lPadding: _padding,
            ),
          ),
        if (user.phoneNumber != null)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: UserInfoField(
              icon: Icons.phone,
              text: user.phoneNumber!,
              lPadding: _padding,
            ),
          ),
        if (user.aboutMe != null)
          OutlinedContainer(
            width: MediaQuery.of(context).size.width - 2 * _padding - 20,
            child: Text(
              user.aboutMe!,
              style: const TextStyle(fontSize: 18),
            ),
          )
      ],
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
