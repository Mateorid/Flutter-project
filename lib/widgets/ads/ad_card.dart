import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_sitting/Models/Ad/ad.dart';
import 'package:pet_sitting/widgets/core/custom_divider.dart';

import '../../styles.dart';

class AdCard extends StatelessWidget {
  const AdCard({Key? key, required this.ad}) : super(key: key);
  final Ad ad;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.75,
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImage(),
            SizedBox(
              width: width * 0.75,
              height: height * 0.11,
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: _buildLeftColumn(context)),
                      ),
                    ),
                    const CustomDivider(),
                    Expanded(flex: 3, child: _buildRightColumn(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      height: 200,
      child: Image.network(
          'https://cdn.pixabay.com/photo/2017/09/25/13/12/puppy-2785074__340.jpg'),
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${ad.costPerHour}€",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: ORANGE_COLOR)),
        const Text("per day")
      ],
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            //todo pet info animal
            Text(ad.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: MAIN_GREEN)),
            // Text("Fufík",
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleMedium
            //         ?.copyWith(fontWeight: FontWeight.bold, color: MAIN_GREEN)),
            // Text("(black labrador)",
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleMedium
            //         ?.copyWith(fontWeight: FontWeight.bold, color: MAIN_GREEN)),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [Icon(Icons.event), SizedBox(width: 5), Text(_getDate())],
        ),
        Row(
          children: [
            Icon(Icons.my_location),
            SizedBox(width: 5),
            Text(ad.location)
          ],
        )
      ],
    );
  }

  String _getDate() {
    String fromParsed = DateFormat("d.M").format(ad.from);
    String toParsed = DateFormat("d.M").format(ad.to);
    return "$fromParsed - $toParsed";
  }
}
