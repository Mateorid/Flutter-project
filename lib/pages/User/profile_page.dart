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
import 'package:pet_sitting/widgets/core/widget_future_builder.dart';
import 'package:pet_sitting/widgets/review/reviewTile.dart';
import 'package:pet_sitting/widgets/review/review_dialog.dart';
import 'package:pet_sitting/widgets/user/profile_widget.dart';
import 'package:pet_sitting/widgets/user/rating_bar.dart';
import 'package:pet_sitting/widgets/user/user_info_field.dart';

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
    final ownProfile = userId == _authService.currentUserId;

    return Stack(children: [
      ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          const SizedBox(height: 25),
          ProfileWidget(
            image: _imageService.getUserImage(user),
            onTap: ownProfile ? () => {context.pushNamed('edit_user')} : null,
          ),
          _buildNameOrEmail(user),
          RatingBar(
            onTap: () => _showDialog(context, user),
            rating: user.averageReviewScore,
            ratingCount: user.reviews.length,
            size: 30,
          ),
          if (!ownProfile) ReviewDialog(user: user),
          const SizedBox(height: 15),
          Center(child: _buildContactInformation(context, user)),
        ],
      ),
      Positioned(
        bottom: 20,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: ownProfile
              ? _buildLogoutButton(context)
              : _buildCloseButton(context),
        ),
      )
    ]);
  }

  void _showDialog(BuildContext context, UserExtended user) {
    // Sort the reviews in descending order based on review.dateTime
    final sortedReviews = List.from(user.reviews)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reviews'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: sortedReviews.length,
            separatorBuilder: (context, index) => const Divider(thickness: 1),
            itemBuilder: (context, index) {
              final review = sortedReviews[index];
              return ReviewTile(review: review);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
    return Center(
      child: IconTextButton(
        color: MAIN_GREEN,
        text: 'Logout',
        onPressed: () => _onLogoutPressed(context),
        icon: Icons.exit_to_app_rounded,
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Center(
      child: IconTextButton(
        color: ERROR_RED,
        text: 'Close',
        onPressed: context.pop,
        icon: Icons.close,
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
