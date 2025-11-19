import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart' as auth;


Future<void> main() async {
  try {
    // Load your service account JSON file
    final jsonString = File("/Users/babu/Documents/Product/Maaka/Code/Recent/maaka-clean/lib/maakanmoney-a6874-75053b1a3a74.json").readAsStringSync();
    final credentials = auth.ServiceAccountCredentials.fromJson(json.decode(jsonString));

    // Define API scopes (example: Firebase Cloud Messaging)
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // Get an authenticated HTTP client
    final client = await auth.clientViaServiceAccount(credentials, scopes);

    // If we reach here, it's valid
    print('✅ Service account is valid!');
    print('Access Token: ${client.credentials.accessToken.data}');
    print('Expires at: ${client.credentials.accessToken.expiry}');

    client.close();
  } catch (e) {
    print('❌ Service account test failed: $e');
  }
}
