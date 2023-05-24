import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/services/date_service.dart';
import 'package:pet_sitting/services/icon_service.dart';
import 'package:pet_sitting/services/image_service.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/ads/ad_detail_small_card.dart';
import 'package:pet_sitting/widgets/core/basic_title.dart';
import 'package:pet_sitting/widgets/core/outlined_container.dart';
import 'package:pet_sitting/widgets/core/widget_future_builder.dart';
import 'package:pet_sitting/widgets/core/widget_stream_builder.dart';

class PetProfilePage extends StatelessWidget {
  late Pet pet;
  final String petId;
  final _iconService = get<IconService>();
  final _dateService = get<DateService>();
  final _imageService = get<ImageService>();

  PetProfilePage({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WidgetFutureBuilder(
          future: get<UserService>().currentUserIsOwnerOfPet(petId),
          onLoaded: (isOwner) => WidgetStreamBuilder(
            stream: get<PetService>().getPetById(petId),
            onLoaded: (p) {
              pet = p!;
              return _buildContent(context, isOwner);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isOwner) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverAppBar(
          floating: true,
          expandedHeight: 250,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: MAIN_GREEN,
            ),
            onPressed: () => {context.pop()},
          ),
          actions: [if (isOwner) _editButton(pet, context)],
          flexibleSpace: FlexibleSpaceBar(background: _petPhoto()),
        ),
        SliverList(delegate: _petInfo(context)),
      ],
    );
  }

  Widget _petPhoto() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _imageService.getPetImage(pet),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverChildListDelegate _petInfo(BuildContext context) {
    return SliverChildListDelegate(
      [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicTitle(text: pet.name),
              const SizedBox(height: 15),
              _buildInfoCards(pet),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: DARK_GREEN),
                ),
              ),
              OutlinedContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  _getDetailsText(pet.details),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInfoCards(Pet pet) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.6,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        AdDetailSmallCard(
          icon: _iconService.getGenderIcon(pet.gender),
          text: pet.gender.text,
        ),
        AdDetailSmallCard(
          icon: Icons.pets,
          text: pet.species.text,
        ),
        AdDetailSmallCard(
          icon: CupertinoIcons.arrow_up_left_arrow_down_right,
          text: pet.size.text,
        ),
        if (pet.breed != null && pet.breed != '')
          AdDetailSmallCard(
            icon: Icons.info_outline,
            text: pet.breed!,
          ),
        if (pet.birthday != null)
          AdDetailSmallCard(
            icon: Icons.date_range,
            text: _dateService.getPrintableDate(pet.birthday!),
          ),
        if (pet.birthday != null)
          AdDetailSmallCard(
            icon: Icons.cake,
            text: _dateService.getAgeFromDate(pet.birthday!),
          ),
      ],
    );
  }

  Widget _editButton(Pet pet, BuildContext context) {
    //todo render this only if user is owner
    return TextButton(
        onPressed: () {
          context.pushNamed('edit_pet', extra: pet);
        },
        child: const Text("Edit",
            style: TextStyle(fontSize: 20, color: MAIN_GREEN)));
  }

  String _getDetailsText(String? text) {
    if (text == null || text == '') {
      return 'Owner did not provide a description.';
    }
    return text;
  }
}
