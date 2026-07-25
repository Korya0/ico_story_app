import 'package:flutter/widgets.dart';

class Gap extends StatelessWidget {
  const Gap(this.gap, {super.key});

  final double gap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: gap, width: gap);
  }
}
