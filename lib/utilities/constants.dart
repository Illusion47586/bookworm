import 'package:flutter/material.dart';
import 'package:auto_animated/auto_animated.dart';

const kGradientFirstColor = Color(0xff4136F1);
const kGradientSecondColor = Color(0xff8743FF);
const kAccentColor = Color(0xff6D3EFA);

const kGradient = LinearGradient(
  colors: [
    kGradientFirstColor,
    kGradientSecondColor,
  ],
);

const double kMasterPadding = 30;

const options = LiveOptions(
  showItemInterval: Duration(milliseconds: 50),
  showItemDuration: Duration(milliseconds: 250),
);
