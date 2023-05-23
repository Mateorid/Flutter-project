import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/widgets/round_button.dart';

import '../styles.dart';

class CreateEditPageTemplate extends StatelessWidget {
  final String pageTitle;
  final String buttonText;
  final VoidCallback buttonCallback;
  final Widget body;
  final bool isLoading;

  const CreateEditPageTemplate({
    super.key,
    required this.pageTitle,
    required this.body,
    required this.buttonText,
    required this.buttonCallback,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: const TextStyle(color: DARK_GREEN),
        ),
        centerTitle: true,
        elevation: 1,
        shadowColor: null,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DARK_GREEN),
          onPressed: () => {context.pop()},
        ),
      ),
      body: body,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RoundButton(
                color: MAIN_GREEN,
                text: buttonText,
                onPressed: buttonCallback,
              ),
      ),
    );
  }
}
