
import 'package:flutter/material.dart';
import 'package:mp_mla_up/utils/Images.dart';

class BgLoginImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Images.vidhanSabha,
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }
}
