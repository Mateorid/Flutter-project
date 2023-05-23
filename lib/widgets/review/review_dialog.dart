import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/Models/review.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/basic_button.dart';

import '../../handle_async_operation.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../plain_text_field.dart';

class ReviewDialog extends StatefulWidget {
  ReviewDialog({Key? key, required this.user}) : super(key: key);
  final UserExtended user;
  final _userService = get<UserService>();
  final _authService = get<AuthService>();

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  double _rating = 3.0;
  final _detailsController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BasicButton(
          text: "Rate this user",
          background: MAIN_GREEN,
          foreground: Colors.white,
          onPressed: () => {_showRating()}),
    );
  }

  Future<void> _showRating() async => await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Rate this user"),
            content: _buildContent(),
            actions: [
              TextButton(
                  onPressed: () {
                    _onSubmitPressed(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Save"))
            ],
          ));

  Widget _buildContent() {
    final reviewAlreadyWritten = widget.user.reviews
        .any((review) => review.fromUser == widget._authService.currentUserId);
    Review existingReview;
    if (reviewAlreadyWritten) {
      existingReview = widget.user.reviews.firstWhere(
          (review) => review.fromUser == widget._authService.currentUserId);
      _detailsController.text = existingReview.text;
      _rating = existingReview.rating.toDouble();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_loading)
          const CircularProgressIndicator() // Show CircularProgressIndicator if _loading is true
        else
          Column(
            children: [
              PlainTextField(
                labelText: "Review",
                placeholder: "Tell us more about your experience",
                maxLines: 5,
                extended: true,
                controller: _detailsController,
                validator: (value) {
                  return null;
                },
              ),
              _buildStars(),
            ],
          ),
      ],
    );
  }

  Widget _buildStars() {
    return RatingBar.builder(
      initialRating: _rating,
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(Icons.star, color: MAIN_GREEN),
      onRatingUpdate: (rating) {
        if (mounted) {
          setState(() {
            _rating = rating;
          });
        }
      },
      updateOnDrag: true,
    );
  }

  Future<void> _saveReview() async {
    final existingReviewIndex = widget.user.reviews.indexWhere(
      (review) => review.fromUser == widget._authService.currentUserId,
    );

    if (existingReviewIndex != -1) {
      // Update existing review
      final updatedReviews = List<Review>.from(widget.user.reviews);
      updatedReviews[existingReviewIndex] = Review(
        rating: _rating.toInt(),
        text: _detailsController.text,
        fromUser: widget._authService.currentUserId ?? '',
        dateTime: DateTime.now(),
      );
      final user = widget.user.copyWith(reviews: updatedReviews);
      widget._userService.updateUserX(user);
    } else {
      // Add new review
      final newReview = Review(
        rating: _rating.toInt(),
        text: _detailsController.text,
        fromUser: widget._authService.currentUserId ?? '',
        dateTime: DateTime.now(),
      );
      final updatedReviews = [...widget.user.reviews, newReview];
      final user = widget.user.copyWith(reviews: updatedReviews);
      widget._userService.updateUserX(user);
    }
  }

  void _onSubmitPressed(BuildContext context) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    await handleAsyncOperation(
      asyncOperation: _saveReview(),
      onSuccessText: 'Review successfully added',
      context: context,
    );

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}
