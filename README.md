# Mobile Farmers Market

Aplikasi Flutter untuk membantu pelanggan memesan produk pasar tani secara online, sekaligus membantu vendor mengelola profil dan produk.

## Fitur Utama
- Autentikasi email/password menggunakan Firebase Authentication.
- Penyimpanan data menggunakan Cloud Firestore.
- Upload gambar produk dan vendor menggunakan Firebase Storage.
- Vendor dapat:
  - menambah/mengubah profil,
  - menambah/mengubah produk,
  - mengelola informasi stok dan harga.
- Pelanggan dapat:
  - melihat market yang akan datang,
  - melihat daftar produk yang tersedia.

## Status Proyek
Proyek ini sudah dimigrasikan ke stack Flutter modern.

Status saat ini:
- Sudah menggunakan null safety.
- Dependensi utama Firebase sudah diperbarui.
- Struktur UI/UX sudah dirapikan.
- Validasi input dan alur form sudah diperkuat.
- `flutter analyze` sudah bersih (No issues found).

## Teknologi
- Flutter
- Dart
- Firebase Core
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Provider
- RxDart

## Struktur Folder
- `lib/main.dart`: entry point aplikasi.
- `lib/src/app.dart`: konfigurasi aplikasi dan provider.
- `lib/src/routes.dart`: routing aplikasi.
- `lib/src/blocs/`: business logic (auth, product, vendor, customer).
- `lib/src/models/`: model data.
- `lib/src/screens/`: halaman aplikasi.
- `lib/src/widgets/`: komponen UI reusable.
- `lib/src/services/`: integrasi Firebase.
- `lib/src/styles/`: konfigurasi tema dan gaya UI.

## Prasyarat
- Flutter SDK terbaru.
- Dart SDK (mengikuti versi Flutter).
- Proyek Firebase aktif.

## Setup Firebase
1. Buat project di Firebase Console.
2. Tambahkan aplikasi Android dan iOS.
3. Aktifkan layanan berikut:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Firebase Storage
4. Letakkan file konfigurasi:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

## Cara Menjalankan
1. Clone repository.
2. Masuk ke folder project.
3. Install dependency:
   - `flutter pub get`
4. Jalankan analisis kode:
   - `flutter analyze`
5. Jalankan aplikasi:
   - `flutter run`

## Catatan
- Folder generated seperti `ios/Flutter/ephemeral/` adalah normal dan dibuat otomatis oleh Flutter.
- Pastikan konfigurasi Firebase sudah benar sebelum login/signup atau upload gambar.

## Lisensi
Silakan gunakan untuk pembelajaran dan pengembangan internal. Jika ingin dipublikasikan ulang, tambahkan lisensi resmi sesuai kebutuhan.
