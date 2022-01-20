import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';

class SendMessageBox extends StatefulWidget {
  final double width;
  final double height;
  const SendMessageBox({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  _SendMessageBoxState createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  late final TextEditingController _phoneNumberInput;
  late final TextEditingController _messageInput;
  String? dialCode;
  bool isValidate = false;
  late PhoneNumber dialValue;

  @override
  void initState() {
    super.initState();
    _phoneNumberInput = TextEditingController();
    _messageInput = TextEditingController();
    dialValue = PhoneNumber(isoCode: 'ID');
  }

  @override
  void dispose() {
    _phoneNumberInput.dispose();
    _messageInput.dispose();
    super.dispose();
  }

  inputValidateCheck() {
    if (dialCode!.isNotEmpty &&
        _phoneNumberInput.text.isNotEmpty &&
        _messageInput.text.isNotEmpty) {
      setState(() {
        isValidate = true;
      });
    } else {
      setState(() {
        isValidate = false;
      });
    }
  }

  sendMessages(String phoneNumber, String message) async {
    String sendUrl;

    if (kIsWeb) {
      sendUrl = "https://wa.me/$phoneNumber/?text=${Uri.parse(message)}";
    } else {
      if (Platform.isAndroid) {
        sendUrl =
            "whatsapp://send?phone=$phoneNumber&text=${Uri.parse(message)}";
      } else {
        sendUrl = "https://wa.me/$phoneNumber/?text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(sendUrl)) {
      await launch(sendUrl, forceSafariVC: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("WhatsApp is not installed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.teal,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InternationalPhoneNumberInput(
              textFieldController: _phoneNumberInput,
              onInputChanged: (phoneNumber) {
                dialValue = phoneNumber;
                dialCode = phoneNumber.dialCode!.replaceAll('+', '');
                inputValidateCheck();
              },
              searchBoxDecoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                labelText: 'Search by country code or dial code',
                labelStyle: GoogleFonts.montserrat(
                  color: Colors.teal,
                ),
              ),
              keyboardAction: TextInputAction.next,
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
              ),
              selectorTextStyle: GoogleFonts.montserrat(),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              initialValue: dialValue,
              spaceBetweenSelectorAndTextField: 0,
              formatInput: false,
              cursorColor: Colors.teal,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              autoFocus: false,
              inputBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: Colors.teal.shade100,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.teal,
                  ),
                ),
                hintText: 'Phone Number',
                hintStyle: GoogleFonts.montserrat(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _messageInput,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                inputValidateCheck();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.teal.shade100,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.teal,
                  ),
                ),
                labelText: 'Message',
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: GoogleFonts.montserrat(),
              ),
              cursorColor: Colors.teal,
              minLines: 8,
              maxLines: 50,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Colors.teal.shade100,
                onPrimary: Colors.teal,
              ),
              onPressed: isValidate
                  ? () {
                      sendMessages(dialCode! + _phoneNumberInput.text,
                          _messageInput.text);
                    }
                  : null,
              child: SizedBox(
                height: 46,
                child: Center(
                  child: Text(
                    'Send Message',
                    style: GoogleFonts.montserrat(
                      color: ThemeData.light().hintColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
