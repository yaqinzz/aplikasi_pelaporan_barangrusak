// ignore: unused_import
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddDamagedItemPage extends StatefulWidget {
  @override
  _AddDamagedItemPageState createState() => _AddDamagedItemPageState();
}

class _AddDamagedItemPageState extends State<AddDamagedItemPage> {
  // Definisikan controller untuk form input
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDescriptionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isSending = false;
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Barang Rusak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _itemNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Barang',
                ),
              ),
              TextField(
                controller: _itemDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Kerusakan',
                ),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                ),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Nomor HP',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSending ? null : () => _sendData(),
                child: Text('Kirim'),
              ),
              SizedBox(height: 10),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendData() async {
    setState(() {
      _isSending = true;
    });

    final nama_barang = _itemNameController.text;
    final deskripsi_kerusakan = _itemDescriptionController.text;
    final alamat = _addressController.text;
    final no_hp = _phoneController.text;

    try {
      // Ganti dengan alamat API yang sesuai
      final apiUrl = 'http://10.0.2.2:3000/api/upload';

      // Kirim data ke API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_barang': nama_barang,
          'deskripsi_kerusakan': deskripsi_kerusakan,
          'alamat': alamat,
          'no_hp': no_hp,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = 'Data berhasil dikirim!';
        });
      } else {
        setState(() {
          _message = 'Gagal mengirim data. Silakan coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  void dispose() {
    // Pastikan untuk menghapus controller saat widget di dispose
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
