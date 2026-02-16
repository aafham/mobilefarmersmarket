# Mobile Farmers Market

Aplikasi Flutter untuk membantu pelanggan memesan produk pasar tani secara online, dan membantu vendor mengelola profil serta produk.

## Ringkasan Fitur
- Login dan signup berbasis Firebase Authentication.
- Data user, vendor, market, dan produk menggunakan Cloud Firestore.
- Vendor dapat:
  - membuat/mengubah profil,
  - menambah/mengubah produk,
  - upload foto produk/vendor.
- Pelanggan dapat melihat daftar market yang akan datang dan produk yang tersedia.

## Status Proyek
Proyek ini berasal dari seri tutorial lama dan masih menggunakan dependensi versi legacy.

Kondisi saat ini:
- Kode sudah diperbaiki untuk beberapa bug UI/UX dan validasi input.
- Struktur project tetap dipertahankan agar kompatibel dengan implementasi awal.
- Untuk menjalankan pada Flutter/Dart terbaru, diperlukan migrasi dependensi Firebase + null safety secara menyeluruh.

## Perbaikan Terbaru
Perbaikan yang sudah diterapkan:
- Memperbaiki bug struktur widget di `lib/src/widgets/card.dart` yang menyebabkan error build.
- Merapikan `lib/src/widgets/products.dart` (menghapus kode duplikat/konflik dan memperjelas state loading/empty).
- Menambahkan hardening validasi input di:
  - `lib/src/blocs/product_bloc.dart`
  - `lib/src/blocs/vendor_bloc.dart`
- Meningkatkan ketahanan model vendor terhadap data null di `lib/src/models/vendor.dart`.
- Menambahkan guard callback null pada `lib/src/widgets/textfield.dart`.
- Menambahkan guard `userId` null pada `lib/src/blocs/auth_bloc.dart`.

## Struktur Folder Utama
- `lib/main.dart`: entry point aplikasi.
- `lib/src/app.dart`: konfigurasi app, provider, dan routing utama.
- `lib/src/blocs/`: business logic (auth, customer, product, vendor).
- `lib/src/models/`: model data aplikasi.
- `lib/src/screens/`: halaman utama (login, signup, landing, edit).
- `lib/src/widgets/`: komponen UI reusable.
- `lib/src/services/`: integrasi Firestore dan Firebase Storage.
- `lib/src/styles/`: konfigurasi gaya, warna, teks, dan tombol.

## Prasyarat
- Flutter SDK (sesuai versi dependensi project).
- Dart SDK.
- Firebase project aktif (Android + iOS app sudah didaftarkan).

Catatan penting kompatibilitas:
- `pubspec.yaml` saat ini masih mengarah ke dependency lama.
- Jika menggunakan Flutter terbaru, jalankan migrasi bertahap sebelum build production.

## Cara Menjalankan
1. Clone repository ini.
2. Masuk ke folder project.
3. Jalankan `flutter pub get`.
4. Pastikan konfigurasi Firebase sudah benar:
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`
5. Jalankan aplikasi:
   - `flutter run`

## Konfigurasi Firebase (Minimum)
- Aktifkan Authentication (Email/Password).
- Buat Cloud Firestore.
- Buat Firebase Storage (jika menggunakan upload gambar).

## Saran Lanjutan
Untuk membawa aplikasi ke standar modern:
1. Migrasi null safety penuh.
2. Upgrade semua package Firebase ke versi terbaru.
3. Ganti API lama yang sudah deprecated (`image_picker`, `permission_handler`, dsb).
4. Tambahkan test unit/integration untuk bloc dan service.

## Lisensi
Gunakan sesuai kebutuhan pembelajaran/pengembangan internal. Tambahkan file lisensi resmi jika project akan dipublikasikan ulang.
