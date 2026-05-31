/// Builds a `wa.me` deep link that opens a WhatsApp chat with a pre-filled
/// message for an arbitrary phone number, without saving it as a contact.
///
/// The dial code and phone number are stripped of any non-digit characters
/// (spaces, dashes, parentheses, a leading `+`) so numbers typed in a
/// human-friendly format still produce a valid link. The message is passed
/// through [Uri]'s query encoding, which correctly escapes spaces, `&`,
/// newlines and other reserved characters.
Uri buildWhatsAppUrl({
  required String dialCode,
  required String phoneNumber,
  required String message,
}) {
  final digitsOnly = RegExp(r'\D');
  final sanitizedNumber = '${dialCode.replaceAll(digitsOnly, '')}'
      '${phoneNumber.replaceAll(digitsOnly, '')}';

  return Uri.https('wa.me', '/$sanitizedNumber', {'text': message});
}
