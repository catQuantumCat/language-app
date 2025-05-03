import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.error});
  final Exception error;

  @override
  Widget build(BuildContext context) {
    return ErrorView(error: error);
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error});

  final Exception error;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
