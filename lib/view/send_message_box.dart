import 'package:anonymous_send_wa/utils/whatsapp_url.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';

class SendMessageBox extends StatefulWidget {
  final double width;
  final double height;
  const SendMessageBox({super.key, required this.width, required this.height});

  @override
  State<SendMessageBox> createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  late final TextEditingController _phoneNumberInput;
  late final TextEditingController _messageInput;
  String? dialCode;
  bool isValidate = false;

  @override
  void initState() {
    super.initState();
    _phoneNumberInput = TextEditingController();
    _messageInput = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberInput.dispose();
    _messageInput.dispose();
    super.dispose();
  }

  void inputValidateCheck() {
    setState(() {
      isValidate = (dialCode?.isNotEmpty ?? false) &&
          _phoneNumberInput.text.isNotEmpty &&
          _messageInput.text.isNotEmpty;
    });
  }

  Future<void> sendMessages(String message) async {
    final sendUrl = buildWhatsAppUrl(
      dialCode: dialCode ?? '',
      phoneNumber: _phoneNumberInput.text,
      message: message,
    );

    final launched = await launchUrl(
      sendUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open WhatsApp")));
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InternationalPhoneNumberInput(
                textFieldController: _phoneNumberInput,
                onInputChanged: (phoneNumber) {
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
                  backgroundColor: Colors.teal.shade100,
                  foregroundColor: Colors.teal,
                ),
                onPressed:
                    isValidate ? () => sendMessages(_messageInput.text) : null,
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
      ),
    );
  }
}
