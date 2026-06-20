# Topvia (Aplikasi TopUp Voucher Game)

TOPVIA adalah aplikasi berbasis web untuk layanan pembelian (top-up) voucher game. Dibangun dengan antarmuka modern bernuansa *Glassmorphism* yang elegan, sistem ini memudahkan pengguna untuk melakukan transaksi dan memudahkan admin dalam mengelola katalog layanan.

## Fitur Utama
* **Multi-User Role:** Akses terpisah antara Pelanggan (User) dan Administrator (Admin).
* **Katalog Premium:** Tampilan daftar layanan voucher yang modern, responsif, dan dinamis langsung dari database.
* **Sistem Transaksi:** Proses pembelian voucher game yang terintegrasi.
* **Manajemen Admin:** Kemudahan bagi admin untuk menambah, mengubah, dan menghapus layanan (CRUD).
* **Riwayat & Laporan:** Perekaman data riwayat transaksi pelanggan dan laporan pendapatan admin.

## Teknologi yang Digunakan
* **Frontend:** HTML5, CSS3, JavaScript, Bootstrap 5 (UI/UX Design)
* **Backend:** Java (JSP & Servlets)
* **Database:** MySQL
* **Tools/IDE:** Apache NetBeans, XAMPP

## Cara Menjalankan Aplikasi Secara Lokal
Jika Anda ingin menjalankan aplikasi ini di komputer Anda sendiri, ikuti langkah-langkah berikut:

1. **Persiapan Database:**
   * Buka XAMPP, jalankan modul **Apache** dan **MySQL**.
   * Buka phpMyAdmin di browser (`http://localhost/phpmyadmin`).
   * Buat database baru bernama `topvia_db` (atau sesuai nama database di project).
   * Import file database `.sql` (jika dilampirkan) ke dalam database tersebut.

2. **Menjalankan Project di NetBeans:**
   * Buka aplikasi **Apache NetBeans**.
   * Pilih menu `File` > `Open Project...` dan pilih folder project TOPVIA.
   * Pastikan library **MySQL JDBC Driver** sudah terpasang pada project.
   * Sesuaikan *username* dan *password* database pada file `Koneksi.java`.
   * Klik kanan pada nama project, lalu pilih **Clean and Build**.
   * Klik kanan lagi, lalu pilih **Run**.
   * Aplikasi akan otomatis terbuka di browser utama Anda.

---
