const express = require('express')
const mysql = require('mysql2/promise') // Use promise-based version
const cors = require('cors')
const bcrypt = require('bcryptjs')

const app = express()
const port = 3000
const host = '127.0.0.1'

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({extended: true}))

// Konfigurasi koneksi database
const pool = mysql.createPool({
  host: 'b2glxbel6c3twu792uro-mysql.services.clever-cloud.com',
  user: 'ufurv19hhza17ifh',
  password: 'sfxQLDKCws38zedcFwcT',
  database: 'b2glxbel6c3twu792uro',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
})

// REGISTER: Tambah pengguna baru
app.post('/api/register', async (req, res) => {
  const {name, username, password} = req.body
  const sql = 'INSERT INTO login (name, username, password) VALUES (?, ?, ?)'

  try {
    const [result] = await pool.query(sql, [name, username, password])
    res.status(200).json({
      status: true,
      message: 'User registered successfully',
      data: {name, username, password},
    })
  } catch (err) {
    console.error('Error adding user:', err.message)
    res.status(500).json({
      status: false,
      message: 'Error adding user',
      error: err.message,
    })
  }
})

let currentUsername = 'Nama Pengguna' // Contoh nama pengguna default

// Endpoint untuk mendapatkan nama pengguna
app.get('/api/username', (req, res) => {
  res.json({username: currentUsername})
})

// Endpoint untuk mengubah kata sandi
app.put('/api/change-password', async (req, res) => {
  const {username, newPassword} = req.body

  if (!username || !newPassword) {
    return res.status(400).json({message: 'Username dan kata sandi baru diperlukan'})
  }

  try {
    const hashedPassword = await bcrypt.hash(newPassword, 10)
    const query = 'UPDATE login SET password = ? WHERE username = ?'
    const [results] = await pool.query(query, [hashedPassword, username])

    if (results.affectedRows === 0) {
      return res.status(404).json({message: 'Pengguna tidak ditemukan'})
    }

    res.json({message: 'Kata sandi berhasil diubah'})
  } catch (err) {
    console.error('Error executing query:', err)
    res.status(500).json({message: 'Terjadi kesalahan. Silakan coba lagi nanti.'})
  }
})

// Endpoint untuk mengubah profil
app.put('/api/change-profile', (req, res) => {
  const {newProfileInfo} = req.body
  console.log(`Profil berhasil diubah menjadi: ${newProfileInfo}`)
  res.json({message: 'Profil berhasil diubah'})
})

// Endpoint untuk mengubah username
app.put('/api/change-username', async (req, res) => {
  const {id, newUsername} = req.body
  console.log(`ID: ${id}, Username: ${newUsername}`)

  if (!id || !newUsername || newUsername.trim() === '') {
    return res.status(400).json({message: 'Permintaan tidak valid'})
  }

  try {
    const query = `UPDATE login SET username = ? WHERE id = ?`
    const [results] = await pool.query(query, [newUsername, id])

    if (results.affectedRows === 0) {
      return res.status(404).json({message: 'Pengguna tidak ditemukan'})
    }

    console.log(`Username berhasil diubah menjadi: ${newUsername}`)
    res.json({message: 'Username berhasil diubah'})
  } catch (error) {
    console.error('Gagal mengubah username:', error)
    res.status(500).json({message: 'Gagal mengubah username'})
  }
})

// LOGIN: Verifikasi pengguna
app.post('/api/login', async (req, res) => {
  const {username, password} = req.body
  const sql = 'SELECT * FROM login WHERE username = ?'

  try {
    const [results] = await pool.query(sql, [username])

    if (results.length > 0) {
      const user = results[0]
      const isPasswordValid = await bcrypt.compare(password, user.password)

      if (isPasswordValid) {
        res.status(200).json({
          status: true,
          message: 'Login successful',
          user: {
            id: user.id,
            username: user.username,
          },
        })
      } else {
        res.status(401).json({
          status: false,
          message: 'Invalid username or password',
        })
      }
    } else {
      res.status(401).json({
        status: false,
        message: 'Invalid username or password',
      })
    }
  } catch (error) {
    console.error('Error during login:', error.message)
    res.status(500).json({
      status: false,
      message: 'Error during login',
      error: error.message,
    })
  }
})

// Endpoint untuk menerima data upload
app.post('/api/upload', async (req, res) => {
  const {nama_barang, deskripsi_kerusakan, alamat, no_hp} = req.body
  const sql = 'INSERT INTO upload (nama_barang, deskripsi_kerusakan, alamat, no_hp) VALUES (?, ?, ?, ?)'

  try {
    const [result] = await pool.query(sql, [nama_barang, deskripsi_kerusakan, alamat, no_hp])
    res.status(200).json({
      status: true,
      message: 'Upload registered successfully',
      data: {nama_barang, deskripsi_kerusakan, alamat, no_hp},
    })
  } catch (err) {
    console.error('Error adding upload:', err.message)
    res.status(500).json({
      status: false,
      message: 'Error adding upload',
      error: err.message,
    })
  }
})

// Endpoint untuk mendapatkan daftar barang rusak
app.get('/api/damaged-items', async (req, res) => {
  const sql = 'SELECT * FROM upload'

  try {
    const [rows] = await pool.query(sql)
    res.status(200).json(rows)
  } catch (err) {
    console.error('Error fetching damaged items:', err.message)
    res.status(500).json({error: err.message})
  }
})

// Menjalankan server pada port 3000
app.listen(port, host, () => {
  console.log(`Server started on port ${host}:${port}`)
})
