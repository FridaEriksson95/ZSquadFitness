import 'package:flutter/material.dart';

class SimpleStreamView<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(T data) builder;
  final Widget empty;
  final bool Function(T data) isEmpty;
  final Widget loading;

  const SimpleStreamView({
    super.key,
    required this.stream,
    required this.builder,
    required this.empty,
    required this.isEmpty,
    this.loading = const Center(child: CircularProgressIndicator()),
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading;
        }
        if (!snapshot.hasData || isEmpty(snapshot.data as T)) {
          return empty;
        }
        return builder(snapshot.data as T);
      },
    );
  }
}
