import 'package:anonymous_send_wa/utils/whatsapp_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildWhatsAppUrl', () {
    test('builds a wa.me link with dial code and number combined', () {
      final uri = buildWhatsAppUrl(
        dialCode: '1',
        phoneNumber: '5551234567',
        message: 'Hello',
      );

      expect(uri.scheme, 'https');
      expect(uri.host, 'wa.me');
      expect(uri.path, '/15551234567');
      expect(uri.queryParameters['text'], 'Hello');
    });

    test('strips spaces, dashes, parentheses and plus from the number', () {
      final uri = buildWhatsAppUrl(
        dialCode: '+1',
        phoneNumber: '(555) 123-4567',
        message: 'Hi',
      );

      expect(uri.path, '/15551234567');
    });

    test('encodes reserved characters in the message', () {
      final uri = buildWhatsAppUrl(
        dialCode: '44',
        phoneNumber: '7700900000',
        message: 'Tom & Jerry: 50% off?',
      );

      expect(uri.queryParameters['text'], 'Tom & Jerry: 50% off?');
      expect(uri.toString(), contains('text=Tom+%26+Jerry%3A+50%25+off%3F'));
    });

    test('preserves newlines in the message', () {
      final uri = buildWhatsAppUrl(
        dialCode: '62',
        phoneNumber: '81234567890',
        message: 'Line one\nLine two',
      );

      expect(uri.queryParameters['text'], 'Line one\nLine two');
    });

    test('handles an empty message', () {
      final uri = buildWhatsAppUrl(
        dialCode: '62',
        phoneNumber: '81234567890',
        message: '',
      );

      expect(uri.path, '/6281234567890');
      expect(uri.queryParameters['text'], '');
    });
  });
}
