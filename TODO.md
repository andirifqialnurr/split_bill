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
