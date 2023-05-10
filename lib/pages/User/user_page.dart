import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/basic_button.dart';
import 'package:pet_sitting/widgets/core/custom_divider.dart';
import 'package:pet_sitting/widgets/round_button.dart';
import 'package:pet_sitting/widgets/user/rating_bard.dart';
import 'package:pet_sitting/widgets/user/user_round_image.dart';

import '../../Models/User/user_extended.dart';
import '../../future_builder.dart';
import '../../handle_async_operation.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../widgets/core/bottom_navigation.dart';

class UserPage extends StatelessWidget {
  final String userId;
  final bool isDetail;
  late UserExtended user;

  UserPage({Key? key, required this.userId, this.isDetail = true})
      : super(key: key);

  final _userService = GetIt.I<UserService>();
  final _authService = GetIt.I<AuthService>();

  @override
  Widget build(BuildContext context) {
    return GenericFutureBuilder(
        future: _userService.getUserById(userId),
        onLoaded: (user) {
          this.user = user;
          return _buildScaffold(context);
        });
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          if (!isDetail) // Conditionally show IconButton if isDetail is set to false
            IconButton(
              onPressed: () {
                _onLogoutPressed(context);
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: MAIN_GREEN,
              ),
            ),
        ],
        leading: isDetail
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: DARK_GREEN,
                ),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      bottomNavigationBar: BottomNavigation(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _buildImage(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildName(context),
                  RatingBar(rating: 3.2, ratingCount: 10),
                  if (!isDetail && userId == _authService.currentUserId)
                    _buildEditButton(context),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
          const Divider(
            thickness: 1,
          ),
          _buildInformation(context),
        ],
      ),
    );
  }

  void _onLogoutPressed(BuildContext context) async {
    await handleAsyncOperation(
        asyncOperation: _authService.signOut(),
        onSuccessText: 'Sign out successful',
        context: context);
    context.go('/login');
  }

  Widget _buildIconAndText(IconData icon, String text, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Icon(
              icon,
              color: MAIN_GREEN,
            ),
            SizedBox(
              width: 10,
            ),
            Text(text),
          ],
        ),
      ],
    );
  }

  Widget _buildInformation(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconAndText(Icons.email, user.email, context),
            user.phoneNumber != null
                ? _buildIconAndText(Icons.phone, user.phoneNumber!, context)
                : Container(),
            user.location != null
                ? _buildIconAndText(Icons.location_on, user.location!, context)
                : Container(),
            const SizedBox(
              height: 10,
            ),
            Text("About: ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, color: DARK_GREEN)),
            const SizedBox(
              height: 5,
            ),
            if (user.aboutMe != null)
              Text(
                user.aboutMe!,
                textAlign: TextAlign.justify,
                maxLines: null,
              ),
          ],
        ));
  }

  Widget _buildEditButton(BuildContext context) {
    return BasicButton(
        text: "EDIT PROFILE",
        background: MAIN_GREEN,
        foreground: Colors.white,
        onPressed: () => {context.pushNamed("edit_user")});
  }

  Widget _buildName(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(user.name ?? user.email,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold, color: DARK_GREEN)),
    ]);
  }

  Widget _buildImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserRoundImage(size: 130, url: user.imageUrl),
      ],
    );
  }
}
