import 'package:flutter/material.dart';

class GenericFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Function(T instance) onLoaded;

  const GenericFutureBuilder(
      {Key? key, required this.future, required this.onLoaded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text("Error: Something went wrong")),
            );
          }
          return onLoaded(snapshot.data as T);
        });
  }
}
