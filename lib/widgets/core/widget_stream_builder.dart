import 'package:flutter/material.dart';

class WidgetStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Function(T instance) onLoaded;

  const WidgetStreamBuilder({
    super.key,
    required this.stream,
    required this.onLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return onLoaded(snapshot.data as T);
      },
    );
  }
}
