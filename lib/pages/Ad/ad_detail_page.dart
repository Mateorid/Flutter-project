import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_sitting/Models/Ad/ad.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/widgets/ads/ad_detail_small_card.dart';
import 'package:pet_sitting/future_builder.dart';
import 'package:pet_sitting/widgets/core/basic_button.dart';
import 'package:pet_sitting/widgets/round_button.dart';

import '../../Models/User/user_extended.dart';
import '../../services/ad_service.dart';
import '../../styles.dart';
import '../../widgets/core/basic_title.dart';
import '../../widgets/user/user_round_image.dart';

class AdDetailPage extends StatelessWidget {
  final String adId;
  final _adService = GetIt.I<AdService>();
  final _userService = GetIt.I<UserService>();
  final _authService = GetIt.I<AuthService>();
  late Ad ad;
  late UserExtended user;

  AdDetailPage({Key? key, required this.adId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericFutureBuilder(
        future: _load(),
        onLoaded: (data) {
          final ad = data[0] as Ad;
          final user = data[1] as UserExtended;
          return _onAdLoaded(context, ad, user);
        });
  }

  Future<List<Object>> _load() async {
    ad = await _adService.getAdById(adId);
    user = await _userService.getUserById(ad.creatorId);
    return [ad, user];
  }

  Widget _onAdLoaded(BuildContext context, Ad ad, UserExtended user) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2017/09/25/13/12/puppy-2785074__340.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(delegate: _adInfo(context)),
        ],
      ),
    );
  }

  SliverChildListDelegate _adInfo(BuildContext context) {
    return SliverChildListDelegate(
      [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPetName(context),
              const SizedBox(height: 10),
              _buildCards(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(ad.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: DARK_GREEN)),
              ),
              if (ad.description != null) _buildAdText(ad.description ?? ""),
              const SizedBox(
                height: 20,
              ),
              _buildUserPart(),
              const SizedBox(
                height: 20,
              ),
              if (ad.creatorId == _authService.currentUserId) _buildEditDelete(context),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ad.creatorId != _authService.currentUserId ? RoundButton(
              color: MAIN_GREEN, text: "Contact user", onPressed: context.pop) : null,
        ),
      ],
    );
  }

  Widget _buildEditDelete(BuildContext context) {
    return Row(children: [
      BasicButton(text: "Edit", background: MAIN_GREEN, foreground: Colors.white, onPressed: () => {_onEditPressed(context)}),
      SizedBox(
        width: 10,
      ),
      BasicButton(text: "Delete", background: ERROR_RED, foreground: Colors.white, onPressed: () => {}),
    ]);
  }

  void _onEditPressed(BuildContext context) {
    context.pushNamed("ad_edit", params: {"id": ad.id ?? ""});
  }


  Widget _buildAdText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        maxLines: null,
      ),
    );
  }

  Widget _buildUserPart() {
    return Row(
      children: [
        UserRoundImage(
          size: 90,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(user.name ?? user.email,
            style: TextStyle(fontWeight: FontWeight.bold, color: DARK_GREEN))
      ],
    );
  }

  Widget _buildPetName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Black labrador",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: MAIN_GREEN)),
        BasicTitle(text: "Fufík"),
      ],
    );
  }

  Widget _buildCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AdDetailSmallCard(
          icon: Icons.my_location,
          text: ad.location,
        ),
        AdDetailSmallCard(
          icon: Icons.event,
          text: _getDate(),
        ),
        AdDetailSmallCard(icon: Icons.euro, text: "${ad.costPerHour}€ per day"),
      ],
    );
  }

  String _getDate() {
    String fromParsed = DateFormat("d.M").format(ad.from);
    String toParsed = DateFormat("d.M").format(ad.to);
    return "$fromParsed - $toParsed";
  }
}
