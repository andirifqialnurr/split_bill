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

- [ ] Buat model draft bill, participant, item, charge, result.
- [ ] Buat formatter rupiah dan parser nominal.
- [ ] Implementasi equal split.
- [ ] Implementasi by items split dengan assignment.
- [ ] Implementasi custom amount split.
- [ ] Implementasi tax/service/discount allocation dan deterministic remainder.
- [ ] Tambahkan unit test calculation invariant.
- [ ] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [ ] Commit dan push checkpoint calculation.

## 4. Local Database

- [ ] Implementasi `SplitBillDatabase` sqflite.
- [ ] Implementasi schema v1 dan index.
- [ ] Implementasi repository save/list/detail bill.
- [ ] Simpan settlement snapshot dalam transaction.
- [ ] Tambahkan test repository dengan database temp bila environment mendukung.
- [ ] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [ ] Commit dan push checkpoint database.

## 5. App State And Navigation

- [ ] Buat controller/state app tanpa cloud dependency.
- [ ] Implementasi Home/history state.
- [ ] Implementasi New Bill step navigation.
- [ ] Pastikan data tidak hilang saat pindah step.
- [ ] Implementasi Settings theme mode.
- [ ] Jika bottom nav dipakai, gunakan floating bottom nav.
- [ ] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [ ] Commit dan push checkpoint state/navigation.

## 6. Bill Entry UI

- [ ] Implementasi mode selection.
- [ ] Implementasi Detail bill form.
- [ ] Implementasi People step.
- [ ] Implementasi Items step.
- [ ] Implementasi Assign Item UI.
- [ ] Implementasi Charges step.
- [ ] Validasi empty, unassigned, incomplete custom, dan negative total.
- [ ] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [ ] Commit dan push checkpoint entry UI.

## 7. Result And History

- [ ] Implementasi Review/Result screen.
- [ ] Implementasi breakdown per peserta.
- [ ] Implementasi expandable item detail.
- [ ] Implementasi Copy Summary.
- [ ] Implementasi Save bill ke history.
- [ ] Implementasi History Detail read-only.
- [ ] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [ ] Commit dan push checkpoint result/history.

## 8. UI Polish And Acceptance

- [ ] Audit spacing konsisten.
- [ ] Audit data yang ditampilkan tidak duplikatif.
- [ ] Audit layout long item name dan 8+ participants.
- [ ] Audit small width behavior 320-359dp.
- [ ] Audit light/dark Result.
- [ ] Jalankan `flutter analyze`, `flutter test --concurrency=1`.
- [ ] Commit dan push checkpoint polish.

## 9. Final Validation

- [ ] `flutter analyze` clean.
- [ ] `flutter test --concurrency=1` pass.
- [ ] `flutter build apk --debug` pass jika SDK Android tersedia.
- [ ] Semua checklist wajib selesai.
- [ ] Commit dan push final state.
