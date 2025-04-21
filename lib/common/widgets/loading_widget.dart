import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingAmoungusState();
}

class _LoadingAmoungusState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 125,
      // width: 125,
      child: Center(
        child: LottieBuilder.asset(
          'assets/animations/loading.json',
          height: 175,
          frameRate: FrameRate(30),
        ),
      ),
    );
  }
}
