Alteon App
Aplikasi mobile berbasis Flutter untuk mempelajari pengembangan aplikasi Android dengan fitur katalog produk, keranjang belanja, checkout, dan riwayat pesanan. Project ini dikembangkan sebagai latihan bertahap untuk memahami Flutter, Dart, pengelolaan state, integrasi REST API, serta pemisahan tanggung jawab kode.
Fitur
- Autentikasi untuk alur masuk pengguna.
- Daftar produk dan halaman detail produk.
- Keranjang belanja
  - Menambahkan produk ke keranjang.
  - Menambah atau mengurangi kuantitas.
  - Menghapus item.
  - Memvalidasi stok sebelum checkout.
- Checkout untuk membuat pesanan.
- Riwayat pesanan dan halaman detail pesanan.
- State management menggunakan Provider dan ChangeNotifier.
- Status UI untuk kondisi loading, error API, keranjang kosong, dan data yang tersedia.
- Ketika refresh keranjang gagal, item yang sebelumnya sudah tampil tetap dipertahankan agar data tidak langsung hilang dari layar.
Teknologi
- Flutter
- Dart
- Provider untuk state management
- REST API sebagai backend
- Laravel API sebagai backend yang digunakan selama pengembangan
- Git dan GitHub untuk version control
Arsitektur dan alur aplikasi
Project ini memisahkan beberapa tanggung jawab agar lebih mudah dipelajari dan dikembangkan:
- Models — merepresentasikan data, seperti Order dan OrderItem.
- Services — menangani komunikasi HTTP dengan API, seperti OrderService.
- Repositories — menjadi lapisan akses data, seperti OrderRepository.
- Providers — mengelola state dan menyediakan data ke widget, seperti OrderProvider.
- Pages / Widgets — menampilkan UI dan menerima interaksi pengguna.
Contoh alur pesanan:

CartPage → checkout → API membuat pesanan → OrderPage → OrderDetailPage

Provider yang digunakan dalam rancangan aplikasi mencakup AuthProvider, ProductProvider, CartProvider, dan OrderProvider.
Backend API
Aplikasi berkomunikasi dengan backend melalui REST API. Selama pengembangan menggunakan Android Emulator, base URL API Laravel yang digunakan adalah:
http://10.0.2.2:8000/api
Alamat 10.0.2.2 adalah alamat khusus yang biasa digunakan Android Emulator untuk mengakses localhost pada komputer host. Alamat ini bukan alamat yang tepat untuk semua perangkat atau lingkungan deployment.

Endpoint pesanan yang digunakan selama pengembangan:
POST /orders
GET  /orders
GET  /orders/{id}
Endpoint dan base URL dapat berbeda sesuai konfigurasi backend yang sedang dijalankan.
Persyaratan
Pastikan perangkat pengembangan sudah memiliki:
- Flutter SDK
- Dart SDK (biasanya disertakan bersama Flutter)
- Android Studio dan Android SDK
- Visual Studio Code atau editor pilihan
- Emulator Android atau perangkat Android fisik
- Backend API Laravel yang sesuai, jika ingin menggunakan fitur yang membutuhkan server
Menjalankan project
1. Clone repository:
   git clone https://github.com/noorman9/alteon-app.git
   cd alteon-app
2. Unduh dependency Flutter:
   flutter pub get
3. Periksa konfigurasi dan perangkat:
   flutter doctor
   flutter devices
4. Jalankan backend API Laravel secara terpisah dan pastikan base URL pada aplikasi sesuai dengan lingkungan yang digunakan.
5. Jalankan aplikasi:
   flutter run
Catatan: langkah menjalankan backend bergantung pada repository backend dan konfigurasi lokalnya. Pastikan backend aktif sebelum menguji fitur yang mengambil atau mengirim data ke server.

Pengembangan dan pembelajaran
Project ini dibuat untuk berlatih konsep-konsep berikut:
- Struktur project Flutter dan pembuatan UI dengan widget.
- Pemisahan model, service, repository, dan provider.
- State management dengan Provider dan ChangeNotifier.
- Navigasi antarhalaman.
- Pemanggilan REST API dan pemrosesan JSON.
- Pengelolaan loading, error, dan empty state.
- Alur keranjang, validasi stok, checkout, serta riwayat pesanan.
- Penggunaan Git dan GitHub untuk menyimpan perkembangan project.
Status
Project dikembangkan secara bertahap sebagai project pembelajaran. Fitur dan konfigurasi dapat berubah mengikuti proses pengembangan. Untuk menjalankan seluruh fitur, diperlukan backend API yang kompatibel.
Lisensi
Belum ditentukan. Tambahkan file lisensi jika project ini nantinya akan didistribusikan secara publik.
