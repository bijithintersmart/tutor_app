import 'package:flutter/material.dart';

class MadeWithFlutter extends StatelessWidget {
  const MadeWithFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20,),
      child: RichText(
        text: TextSpan(
          text: "Made with",
          children: [WidgetSpan(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FlutterLogo(),
          ))],
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(letterSpacing: .5),
        ),
      ),
    );
  }
}
