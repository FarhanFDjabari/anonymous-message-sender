import 'package:anonymous_send_wa/components/adaptive_text.dart';
import 'package:anonymous_send_wa/components/entrance_fader.dart';
import 'package:anonymous_send_wa/view/send_message_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            'images/lottie-background.json',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: deviceWidth < 780
                  ? deviceHeight * 0.025
                  : deviceHeight * 0.05,
              horizontal:
                  deviceWidth < 780 ? deviceWidth * 0.05 : deviceWidth * 0.25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EntranceFader(
                  duration: const Duration(milliseconds: 250),
                  offset: const Offset(0, -10),
                  child: AdaptiveText(
                    'Send WhatsApp Messages to Any Phone Number',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: deviceHeight * 0.05),
                EntranceFader(
                  duration: const Duration(milliseconds: 250),
                  offset: const Offset(0, -10),
                  delay: const Duration(milliseconds: 250),
                  child: SendMessageBox(
                    width: deviceWidth * 0.75,
                    height: deviceHeight * 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
