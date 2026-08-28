# Split Bill TODO

Kerjakan berurutan. Setelah setiap task utama selesai, jalankan validasi relevan, commit, lalu push. Status push harus dilaporkan terpisah dari status commit.

## 1. Foundation Docs

- [x] Buat `PRD.md` untuk scope wajib.
- [x] Buat `SCHEMA.md` untuk SQLite sqflite.
- [x] Buat `ARCHITECTURE.md` untuk struktur app.
- [x] Buat `DESIGN-SYSTEM.md` untuk UI light/dark.
- [x] Buat `TODO.md` sebagai tracker kerja.
- [x] Commit dan push checkpoint dokumentasi.

## 2. Flutter Project Setup

- [x] Tambahkan dependency `sqflite`, `path`, dan `intl`.
- [x] Ganti counter template dengan bootstrap app Split Bill.
- [x] Buat struktur folder `core`, `data`, `domain`, `features`, `ui`.
- [x] Buat theme light/dark sesuai `DESIGN-SYSTEM.md`.
- [x] Tambahkan widget test smoke untuk Home.
- [x] Jalankan `flutter pub get`, `flutter analyze`, `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint setup.

## 3. Domain Calculation

- [x] Buat model draft bill, participant, item, charge, result.
- [x] Buat formatter rupiah dan parser nominal.
- [x] Implementasi equal split.
- [x] Implementasi by items split dengan assignment.
- [x] Implementasi custom amount split.
- [x] Implementasi tax/service/discount allocation dan deterministic remainder.
- [x] Tambahkan unit test calculation invariant.
- [x] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint calculation.

## 4. Local Database

- [x] Implementasi `SplitBillDatabase` sqflite.
- [x] Implementasi schema v1 dan index.
- [x] Implementasi repository save/list/detail bill.
- [x] Simpan settlement snapshot dalam transaction.
- [x] Tambahkan test repository dengan database temp bila environment mendukung.
- [x] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint database.

## 5. App State And Navigation

- [x] Buat controller/state app tanpa cloud dependency.
- [x] Implementasi Home/history state.
- [x] Implementasi New Bill step navigation.
- [x] Pastikan data tidak hilang saat pindah step.
- [x] Implementasi Settings theme mode.
- [x] Jika bottom nav dipakai, gunakan floating bottom nav.
- [x] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint state/navigation.

## 6. Bill Entry UI

- [x] Implementasi mode selection.
- [x] Implementasi Detail bill form.
- [x] Implementasi People step.
- [x] Implementasi Items step.
- [x] Implementasi Assign Item UI.
- [x] Implementasi Charges step.
- [x] Validasi empty, unassigned, incomplete custom, dan negative total.
- [x] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint entry UI.

## 7. Result And History

- [x] Implementasi Review/Result screen.
- [x] Implementasi breakdown per peserta.
- [x] Implementasi expandable item detail.
- [x] Implementasi Copy Summary.
- [x] Implementasi Save bill ke history.
- [x] Implementasi History Detail read-only.
- [x] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint result/history.

## 8. UI Polish And Acceptance

- [x] Audit spacing konsisten.
- [x] Audit data yang ditampilkan tidak duplikatif.
- [x] Audit layout long item name dan 8+ participants.
- [x] Audit small width behavior 320-359dp.
- [x] Audit light/dark Result.
- [x] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint polish.

## 9. Final Validation

- [x] `flutter analyze` clean.
- [x] `flutter test --concurrency=1` pass.
- [x] `flutter build apk --debug` pass jika SDK Android tersedia.
- [x] Semua checklist wajib selesai.
- [x] Commit dan push final state.
