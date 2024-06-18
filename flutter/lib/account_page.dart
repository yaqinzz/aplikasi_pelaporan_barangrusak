import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String username = "";
  int userId = 0;
  final String profileImageUrl = "https://via.placeholder.com/150";

  @override
  void initState() {
    super.initState();
    getUsernameFromApi(); // Panggil fungsi untuk mendapatkan nama pengguna dari API
  }

  Future<void> getUsernameFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        username = prefs.getString('username') ?? "Nama Pengguna";
        userId = prefs.getInt('userId') ?? -1;
      });
      // final response =
      //     await http.get(Uri.parse('http://10.0.2.2:3000/api/username'));
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   setState(() {
      //     username = data['username'];
      //   });
      // } else {
      //   // Handle jika gagal mendapatkan data
      //   print('Gagal mendapatkan nama pengguna');
      // }
    } catch (error) {
      // Handle error ketika terjadi kesalahan koneksi atau lainnya
      print('Error: $error');
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      print('Sending change password request with username: $username');
      print('New password: $newPassword');
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/change-password'),
        body: jsonEncode({
          'username':
              username, // Mengirim username sebagai bagian dari body request
          'newPassword': newPassword,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kata sandi berhasil diubah'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengubah kata sandi'),
          ),
        );
        print('Gagal mengubah kata sandi');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> changeProfile(String newProfileInfo) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/change-profile'),
        body: jsonEncode({'newProfileInfo': newProfileInfo}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diubah'),
          ),
        );
      } else {
        print('Gagal mengubah profil');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> changeUsername(String newUsername) async {
    try {
      print(
          'Mengubah username dari $username menjadi $newUsername untuk userID: $userId');
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/change-username'),
        body: jsonEncode({'id': userId, 'newUsername': newUsername}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username berhasil diubah'),
          ),
        );
        setState(() {
          username =
              newUsername; // Update nama pengguna di aplikasi setelah berhasil diubah
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengubah username'),
          ),
        );
        print('Gagal mengubah username');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              const SizedBox(height: 16),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Ubah Kata Sandi'),
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Ubah Profil'),
                onTap: () {
                  _showEditProfileDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Ubah Username'),
                onTap: () {
                  _showChangeUsernameDialog(context);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Keluar'),
                onPressed: () {
                  // Logika untuk keluar (logout)
                  Navigator.pop(context); // Keluar dari halaman akun
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    String newPassword = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Kata Sandi'),
          content: TextField(
            decoration: InputDecoration(hintText: "Masukkan kata sandi baru"),
            obscureText: true,
            onChanged: (value) {
              newPassword = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                changePassword(newPassword);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    String newProfileInfo = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Profil'),
          content: TextField(
            decoration:
                InputDecoration(hintText: "Masukkan informasi profil baru"),
            onChanged: (value) {
              newProfileInfo = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                changeProfile(newProfileInfo);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangeUsernameDialog(BuildContext context) {
    String newUsername = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Username'),
          content: TextField(
            decoration: InputDecoration(hintText: "Masukkan username baru"),
            onChanged: (value) {
              newUsername = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                changeUsername(newUsername);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
