import 'package:flutter/material.dart';

class SmallDurationText extends StatelessWidget {
  final Duration? duration;
  const SmallDurationText({super.key, this.duration});

  @override
  Widget build(BuildContext context) {
    return Text(
      duration?.toString().substring(6, 9) ?? "",
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}
