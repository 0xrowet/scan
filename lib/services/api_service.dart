import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> scanProduct(
    String productId, 
    String qty,
    String serverIp,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://$serverIp:5000/scan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_id': productId, 'qty': qty}),
      );

      return json.decode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to connect to server: $e'
      };
    }
  }
}
