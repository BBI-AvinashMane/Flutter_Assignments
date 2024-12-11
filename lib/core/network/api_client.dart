// core/network/api_client.dart
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;

  ApiClient(this.client);

  Future<http.Response> get(String url) async {
    return await client.get(Uri.parse(url));
  }
}



