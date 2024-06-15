const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;
const host = 'localhost';

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Konfigurasi koneksi database
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'aplikasi_jasa'
});

// Connect ke database
db.connect(err => {
  if (err) {
    console.error('Error connecting to MySQL:', err.message);
    process.exit(1);
  }
  console.log('MySQL Connected...');
});

// REGISTER: Tambah pengguna baru
app.post('/api/register', async (req, res) => {
  const { name, username, password } = req.body;
  const sql = 'INSERT INTO login (name, username, password) VALUES (?, ?, ?)';
  db.query(sql, [name, username, password], (err, result) => {
    if (err) {
      console.error('Error adding user:', err.message);
      return res.status(500).json({
        status: false,
        message: 'Error adding user',
        error: err.message
      });
    }
    res.status(200).json({
      status: true,
      message: 'User registered successfully',
      data: { name, username, password }
    });
  });
});

let currentUsername = 'Nama Pengguna'; // Contoh nama pengguna default

// Endpoint untuk mendapatkan nama pengguna
app.get('/api/username', (req, res) => {
  res.json({ username: currentUsername });
});

// Endpoint untuk mengubah kata sandi
app.put('/api/change-password', (req, res) => {
  const { newPassword } = req.body;
  console.log(`Kata sandi berhasil diubah menjadi: ${newPassword}`);
  res.json({ message: 'Kata sandi berhasil diubah' });
});

// Endpoint untuk mengubah profil
app.put('/api/change-profile', (req, res) => {
  const { newProfileInfo } = req.body;
  console.log(`Profil berhasil diubah menjadi: ${newProfileInfo}`);
  res.json({ message: 'Profil berhasil diubah' });
});

// Endpoint untuk mengubah username
app.put('/api/change-username', (req, res) => {
  const { newUsername } = req.body;
  console.log(`Username berhasil diubah menjadi: ${newUsername}`);
  currentUsername = newUsername; // Update nama pengguna di server
  res.json({ message: 'Username berhasil diubah' });
});

// LOGIN: Verifikasi pengguna
app.post('/api/login', async (req, res) => {
  const { username, password } = req.body;
  const sql = 'SELECT * FROM login WHERE username = ? AND password = ?';
  db.query(sql, [username, password], (err, result) => {
    if (err) {
      console.error('Error during login:', err.message);
      return res.status(500).json({
        status: false,
        message: 'Error during login',
        error: err.message
      });
    }
    if (result.length > 0) {
      res.status(200).json({
        status: true,
        message: 'Login successful',
        user: result[0]
      });
    } else {
      res.status(401).json({
        status: false,
        message: 'Invalid username or password'
      });
    }
  });
});

// Endpoint untuk menerima data upload
app.post('/api/upload', async (req, res) => {
  const { nama_barang, deskripsi_kerusakan, alamat, no_hp } = req.body;
  const sql = 'INSERT INTO upload (nama_barang, deskripsi_kerusakan, alamat, no_hp) VALUES (?, ?, ?, ?)';
  db.query(sql, [nama_barang, deskripsi_kerusakan, alamat, no_hp], (err, result) => {
    if (err) {
      console.error('Error adding upload:', err.message);
      return res.status(500).json({
        status: false,
        message: 'Error adding upload',
        error: err.message
      });
    }
    res.status(200).json({
      status: true,
      message: 'Upload registered successfully',
      data: { nama_barang, deskripsi_kerusakan, alamat, no_hp }
    });
  });
});

// Endpoint untuk mendapatkan daftar barang rusak
app.get('/api/damaged-items', (req, res) => {
  const sql = 'SELECT * FROM upload';
  db.query(sql, (err, rows) => {
    if (err) {
      console.error('Error fetching damaged items:', err.message);
      return res.status(500).json({ error: err.message });
    }
    res.status(200).json(rows); // Respond with 200 OK and the fetched data
  });
});

// Menjalankan server pada port 3000
app.listen(port, host, () => {
  console.log(`Server started on port ${host}:${port}`);
});
