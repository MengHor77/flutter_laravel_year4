import '../api_config.dart';
import 'package:http/http.dart' as http;

class SpecialOffersService {
  // Purely handles the network request
  static Future<http.Response> fetchOffers() async {
    return await http.get(Uri.parse(ApiConfig.specialOffers));
  }
}
  