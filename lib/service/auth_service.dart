import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class AuthService {
  Future<String> authenticate() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'x-sinric-api-key': dotenv.env["SINRICPRO_API_KEY"] ?? ""
    };
    var request =
        Request('POST', Uri.parse('https://api.sinric.pro/api/v1/auth'));
    request.bodyFields = {'client_id': dotenv.env["CLIENT_ID"] ?? ""};
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    return await response.stream.bytesToString();
  }
}
