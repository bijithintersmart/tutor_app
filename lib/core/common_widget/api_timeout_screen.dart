import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:tutor_app/core/constant/app_strings.dart';
// import 'package:tutor_app/core/utils/common_widgets.dart/normal_text.dart';
import 'package:lottie/lottie.dart';

class ApiTimeoutErrorScreen extends StatelessWidget {
  const ApiTimeoutErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  'assets/lotties/server_issue.json',
                  width: 300,
                ),
                SizedBox(height: 20),
                Text(
                  'Oops! Connection Lost',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "It seems we've lost connection. Please try again later. Our service is temporarily unavailable, but we're working hard to get back up and running. Thank you for your patience!",

                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(
                    'Exit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
