import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:anonymous_send_wa/utils/whatsapp_url.dart';

typedef LauncherCallback = Future<bool> Function(Uri url);

Future<bool> _defaultLauncher(Uri url) =>
    launchUrl(url, mode: LaunchMode.externalApplication);

class MessageForm extends StatefulWidget {
  final LauncherCallback launcher;

  const MessageForm({
    super.key,
    this.launcher = _defaultLauncher,
  });

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _messageController;
  String? _dialCode;
  bool _isFormValid = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    setState(() {
      _isFormValid = (_dialCode?.isNotEmpty ?? false) &&
          _phoneNumberController.text.isNotEmpty &&
          _messageController.text.isNotEmpty;
    });
  }

  Future<void> _sendMessage() async {
    setState(() => _isSending = true);

    try {
      final url = buildWhatsAppUrl(
        dialCode: _dialCode ?? '',
        phoneNumber: _phoneNumberController.text,
        message: _messageController.text,
      );

      final launched = await widget.launcher(url);

      if (!mounted) return;

      if (launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening WhatsApp...'),
            duration: Duration(milliseconds: 1500),
          ),
        );
        // Clear message field only on success
        _messageController.clear();
        _updateFormValidity();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open WhatsApp'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            // Phone number input
            InternationalPhoneNumberInput(
              textFieldController: _phoneNumberController,
              initialValue: PhoneNumber(isoCode: 'US'),
              onInputChanged: (phoneNumber) {
                _dialCode = phoneNumber.dialCode?.replaceAll('+', '');
                _updateFormValidity();
              },
              searchBoxDecoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                labelText: 'Search by country code or dial code',
                labelStyle: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              keyboardAction: TextInputAction.next,
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
              ),
              selectorTextStyle: GoogleFonts.inter(),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              formatInput: false,
              cursorColor: Theme.of(context).colorScheme.primary,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              autoFocus: false,
              inputBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              inputDecoration: InputDecoration(
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF1F2937) : const Color(0xFFFAFAFA),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                hintText: 'Phone Number',
                hintStyle: GoogleFonts.inter(),
              ),
            ),
            // Message input
            TextField(
              controller: _messageController,
              keyboardType: TextInputType.multiline,
              onChanged: (_) => _updateFormValidity(),
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Message',
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                hintText: 'Enter your message',
                hintStyle: GoogleFonts.inter(),
              ),
              style: GoogleFonts.inter(),
            ),
            // Send button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isFormValid && !_isSending ? _sendMessage : null,
                child: _isSending
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Send Message',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
