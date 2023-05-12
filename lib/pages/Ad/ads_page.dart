import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/Ad/ad.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/pages/page_template.dart';
import 'package:pet_sitting/services/ad_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/ads/ad_card.dart';

class AdsPage extends StatelessWidget {
  AdsPage({Key? key}) : super(key: key);

  final _adService = get<AdService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTemplate(
        pageTitle: 'Ads',
        body: StreamBuilder<List<Ad>>(
          stream: _adService.adStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final ads = snapshot.data!;

            if (ads.isEmpty) {
              return const Center(child: Text('No ads yet.'));
            }
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final ad = ads[index];
                          print(ad.id);
                          return InkWell(
                            onTap: () {
                              context.pushNamed("ad_details",
                                  params: {"id": ad.id ?? ""});
                            },
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                AdCard(ad: ad),
                              ],
                            ),
                          );
                        },
                        itemCount: ads.length,
                      ),
                    ),
                  ],
                ),
                _buildAddButton(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: MAIN_GREEN,
        onPressed: () {
          _onAddPressed(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onAddPressed(BuildContext context) {
    context.pushNamed("create_add");
  }
}
