import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepairPage extends StatefulWidget {
  @override
  _RepairPageState createState() => _RepairPageState();
}

class _RepairPageState extends State<RepairPage> {
  List<dynamic> _damagedItems = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchDamagedItems();
  }

  Future<void> _fetchDamagedItems() async {
    const String urlApi =
        'http://10.0.2.2:3000/api/damaged-items'; // Update with your API URL
    final url = Uri.parse(urlApi);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _damagedItems = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang Rusak'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(child: Text('Gagal memuat data'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _damagedItems.length,
                    itemBuilder: (context, index) {
                      final item = _damagedItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Icon(Icons.broken_image,
                              size: 40, color: Colors.red),
                          title: Text(
                            item['nama_barang'] ?? 'Nama Barang Tidak Tersedia',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(item['deskripsi_kerusakan'] ??
                              'Deskripsi Tidak Tersedia'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _showItemDetails(item);
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _showItemDetails(dynamic item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item['nama_barang'] ?? 'Nama Barang Tidak Tersedia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['deskripsi_kerusakan'] ?? 'Deskripsi Tidak Tersedia',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Alamat: ${item['alamat'] ?? 'Alamat Tidak Tersedia'}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Nomor HP: ${item['no_hp'] ?? 'Nomor HP Tidak Tersedia'}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              // Optional: Display image if available
              if (item['image'] != null && item['image'] is String)
                Image.network(item['image']),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
