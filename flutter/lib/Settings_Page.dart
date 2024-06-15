import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Ubah Kata Sandi'),
            onTap: () {
              // Navigasi ke halaman ubah kata sandi
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Mode Gelap'),
            trailing: Switch(
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                  // Logika untuk mengubah tema aplikasi
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Aktifkan Notifikasi'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                  // Logika untuk mengubah pengaturan notifikasi
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Bahasa'),
            subtitle: Text(_selectedLanguage),
            onTap: () {
              _selectLanguage(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Kebijakan Privasi'),
            onTap: () {
              // Navigasi ke halaman kebijakan privasi
            },
          ),
        ],
      ),
    );
  }

  void _selectLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Bahasa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'English';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Bahasa Indonesia'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'Bahasa Indonesia';
                  });
                  Navigator.of(context).pop();
                },
              ),
              // Tambahkan opsi bahasa lainnya di sini
            ],
          ),
        );
      },
    );
  }
}
