# Split Bill Active TODO

Tracker aktif untuk melanjutkan pekerjaan dari referensi visual `main2.dart` dan `DESIGN-SYSTEM (1).md`.
Dokumen historis tetap ada di `cookbook/`; file ini dipakai sebagai checklist implementasi berjalan.

Aturan kerja:

- Kerjakan task berurutan.
- Setelah setiap task utama selesai: jalankan validasi relevan, update checklist, commit, lalu push.
- Laporkan status commit dan push secara terpisah.
- Jangan mengganti domain calculation atau SQLite persistence yang sudah berjalan kecuali perlu untuk menyambungkan UI.

## 1. Rencana Migrasi UI

- [x] Audit `main2.dart`, `DESIGN-SYSTEM (1).md`, dan kode aktif.
- [x] Tetapkan batas migrasi: presentasi mengikuti referensi; state, calculator, repository, dan persistence tetap dari kode aktif.
- [x] Commit dan push checkpoint rencana.

## 2. Design Foundation

- [x] Selaraskan spacing, radius, palette light/dark, typography, dan app theme dengan referensi.
- [x] Tambahkan reusable component foundation: card, screen layout, buttons, text field, empty state, warning banner, participant avatar/chip, mode badge, summary row, money text, dan floating nav.
- [x] Pastikan widget foundation tetap memakai Material icons dan tidak membutuhkan dependency baru yang belum tersedia lokal.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint design foundation.

## 3. Home, Settings, Dan Navigation

- [x] Migrasikan Home agar first screen terasa seperti app aktual: header, quick actions, empty state, recent bills, dan history card sesuai referensi.
- [x] Migrasikan Settings theme mode System/Light/Dark dengan segmented control yang konsisten.
- [x] Pastikan floating bottom nav tetap ergonomic dan tidak menutup konten.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint home/settings/navigation.

## 4. New Bill Wizard

- [x] Migrasikan step detail dan mode selection.
- [x] Migrasikan people step dengan avatar/chip, edit, remove, dan cleanup confirmation.
- [x] Migrasikan item entry, item tile, assignment sheet, dan unassigned state.
- [x] Migrasikan charges/custom amount/review dengan validation helper yang jelas.
- [x] Pastikan draft tidak hilang saat pindah step atau menekan back.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint wizard.

## 5. Result, History, Dan Acceptance

- [x] Migrasikan `ResultView` agar Result dan History Detail memakai komponen breakdown yang sama.
- [x] Pastikan Copy Summary dan Save bill tetap bekerja.
- [x] Pastikan long item name, 8+ participants, light/dark, dan width kecil punya guard layout.
- [x] Jalankan `flutter analyze`, `flutter test --concurrency=1`, dan `flutter build apk --debug` bila Android SDK tersedia.
- [x] Commit dan push final state.

## 6. Language Foundation

Target: aplikasi mendukung Bahasa Indonesia dan English tanpa package i18n baru dulu.

Commit plan:

- Commit 1: model bahasa, state, controller, dan kamus teks dasar.
- Commit 2: test smoke untuk pergantian bahasa.

Checklist:

- [x] Tambahkan enum `AppLanguage` dengan nilai `id` dan `en`.
- [x] Simpan pilihan bahasa di app state.
- [x] Tambahkan controller action untuk mengganti bahasa.
- [x] Buat helper teks lokal, misalnya `SplitStrings`.
- [x] Pastikan default bahasa tetap Indonesia.
- [x] Tambahkan test untuk render Indonesia dan English.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint language foundation.

## 7. Settings Language Selector

Target: pilihan bahasa disimpan di halaman Settings.

Commit plan:

- Commit 1: UI selector bahasa di Settings.
- Commit 2: sinkronisasi copy Settings agar ringkas.

Checklist:

- [x] Tambahkan section `Language` di Settings.
- [x] Tambahkan segmented control `Indonesia` / `English`.
- [x] Pastikan pilihan langsung mengubah teks aplikasi.
- [x] Ringkas deskripsi Settings yang terlalu panjang.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint settings language.

## 8. UI Copy Localization And Cleanup

Target: semua teks utama tersedia dalam dua bahasa dan deskripsi dibuat lebih pendek.

Commit plan:

- Commit 1: Home, navigation, Settings.
- Commit 2: New Bill wizard.
- Commit 3: Result, History, snackbar, dialog, dan error.

Checklist:

- [x] Lokalkan teks Home.
- [x] Lokalkan teks bottom navigation.
- [x] Lokalkan teks Settings.
- [x] Lokalkan teks New Bill detail, people, items, charges, custom, dan result step.
- [x] Lokalkan teks Result dan History Detail.
- [x] Lokalkan snackbar, dialog, empty state, warning, dan validation error.
- [x] Pendekkan copy yang panjang menjadi satu kalimat pendek.
- [x] Pastikan label tombol tetap jelas.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint copy localization.

## 9. Language Acceptance

Target: fitur bahasa selesai dan tidak mengganggu split bill flow.

Commit plan:

- Commit 1: final validation dan checklist.

Checklist:

- [x] Uji acceptance otomatis flow Indonesia: Home -> New Bill -> Result.
- [x] Uji acceptance otomatis flow English: Home -> New Bill -> Result.
- [x] Pastikan Settings tetap bisa mengganti theme dan language.
- [x] Pastikan Copy Summary mengikuti bahasa aktif.
- [x] Jalankan `flutter analyze`.
- [x] Jalankan `flutter test --concurrency=1`.
- [x] Jalankan `flutter build apk --debug` bila Android SDK tersedia.
- [x] Commit dan push final language state.
