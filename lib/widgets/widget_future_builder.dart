import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';

class WidgetFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Function(T instance) onLoaded;

  const WidgetFutureBuilder(
      {super.key, required this.future, required this.onLoaded});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error: Something went wrong!",
              style: TextStyle(
                color: ERROR_RED,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return onLoaded(snapshot.data as T);
      },
    );
  }
}
