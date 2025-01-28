import 'package:flutter/material.dart';
import '../utils/styles.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: AppStyles.errorTextStyle,
    );
  }
}
