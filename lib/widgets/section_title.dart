import 'package:flutter/material.dart';

import '../consts/strings.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.sectionName,
    required this.pressMore,
  });

  final String sectionName;
  final GestureTapCallback pressMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            sectionName,
            style: const TextStyle(fontSize: 24, fontFamily: bold),
          ),
          GestureDetector(
              onTap: pressMore,
              child: const Text('See All', style: TextStyle(fontSize: 16)))
        ],
      ),
    );
  }
}