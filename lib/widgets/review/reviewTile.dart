import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/Models/review.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/widget_future_builder.dart';
import 'package:pet_sitting/widgets/user/rating_bar.dart';
import 'package:pet_sitting/widgets/user/user_round_image.dart';

class ReviewTile extends StatelessWidget {
  final Review review;
  final _userService = get<UserService>();

  ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return WidgetFutureBuilder(
      future: _userService.getUserById(review.fromUser),
      onLoaded: (user) => _buildContent(context, user),
    );
  }

  Widget _buildContent(BuildContext context, UserExtended user) {
    return ListTile(
      leading: UserRoundImage(
        size: 90,
        url: user.imageUrl,
      ),
      title: RatingBar(rating: review.rating.toDouble(), ratingCount: null),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name ?? user.email,
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: MAIN_GREEN),
          ),
          const SizedBox(height: 3),
          Text(review.text),
          const SizedBox(height: 3),
          Text(DateFormat.yMMMd().format(review.dateTime),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }
}
