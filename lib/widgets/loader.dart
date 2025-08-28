import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double size;
  final Color color;

  const Loader({
    super.key,
    this.size = 30,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
