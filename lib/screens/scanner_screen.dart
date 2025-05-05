import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanner_kasir/services/api_service.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ApiService _apiService = ApiService();
  String _serverIp = '192.168.1.2';
  String _statusMessage = '';
  bool _isLoading = false;

  Future<void> _scanBarcode() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 
        'Cancel', 
        true, 
        ScanMode.BARCODE,
      );

      if (barcode != '-1') {
        final response = await _apiService.scanProduct(
          barcode, 
          '1', // Default qty
          _serverIp,
        );

        setState(() {
          _statusMessage = response['message'];
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasir Scanner'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen(
                serverIp: _serverIp,
                onSave: (ip) => setState(() => _serverIp = ip),
              )),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) CircularProgressIndicator(),
            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage.contains('berhasil') 
                      ? Colors.green 
                      : Colors.red,
                  ),
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Server: $_serverIp',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBarcode,
        tooltip: 'Scan',
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
