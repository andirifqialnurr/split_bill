# Split Bill TODO

Tracker tunggal untuk pekerjaan Split Bill. Isi historis dari `cookbook/TODO.md` sudah digabung ke file ini supaya kelanjutan kerja tidak terpecah di dua checklist.

Aturan kerja:

- Kerjakan task berurutan per checkpoint yang jelas.
- Setelah setiap task utama selesai: jalankan validasi relevan, update checklist, commit, lalu push.
- Laporkan status commit dan push secara terpisah.
- Jangan mengganti domain calculation atau SQLite persistence yang sudah berjalan kecuali perlu untuk fitur yang sedang dikerjakan.
- Untuk perubahan UI, pertahankan pola visual aktif: floating shell, bottom nav icon-only, FAB `+` untuk pencatatan bill, dan copy ringkas.

## 1. MVP Foundation

- [x] Buat `PRD.md` untuk scope wajib.
- [x] Buat `SCHEMA.md` untuk SQLite sqflite.
- [x] Buat `ARCHITECTURE.md` untuk struktur app.
- [x] Buat `DESIGN-SYSTEM.md` untuk UI light/dark.
- [x] Tambahkan dependency `sqflite`, `path`, dan `intl`.
- [x] Ganti counter template dengan bootstrap app Split Bill.
- [x] Buat struktur folder `core`, `data`, `domain`, `features`, `ui`.
- [x] Buat theme light/dark sesuai design system.
- [x] Tambahkan widget test smoke untuk Home.
- [x] Jalankan `flutter pub get`, `flutter analyze`, dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint foundation.

## 2. Domain Calculation

- [x] Buat model draft bill, participant, item, charge, dan result.
- [x] Buat formatter rupiah dan parser nominal.
- [x] Implementasi equal split.
- [x] Implementasi by-items split dengan assignment.
- [x] Implementasi custom amount split.
- [x] Implementasi tax/service/discount allocation dan deterministic remainder.
- [x] Tambahkan unit test calculation invariant.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint calculation.

## 3. Local Database

- [x] Implementasi `SplitBillDatabase` sqflite.
- [x] Implementasi schema v1 dan index.
- [x] Implementasi repository save/list/detail bill.
- [x] Simpan settlement snapshot dalam transaction.
- [ ] Tambahkan repository test dengan database temp bila environment mendukung.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint database.

## 4. App State And Navigation

- [x] Buat controller/state app tanpa cloud dependency.
- [x] Implementasi Home/history state.
- [x] Implementasi New Bill step navigation.
- [x] Pastikan data tidak hilang saat pindah step.
- [x] Implementasi Settings theme mode.
- [x] Gunakan floating bottom nav untuk shell utama.
- [x] Tambahkan tab Riwayat di bottom nav.
- [x] Ubah bottom nav menjadi icon-only.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint state/navigation.

## 5. Bill Entry UI

- [x] Implementasi mode selection.
- [x] Implementasi Detail bill form.
- [x] Implementasi People step.
- [x] Implementasi Items step.
- [x] Implementasi Assign Item UI.
- [x] Implementasi Charges step.
- [x] Validasi empty, unassigned, incomplete custom, dan negative total.
- [x] Migrasikan wizard ke visual aktif.
- [x] Pastikan draft tidak hilang saat pindah step atau menekan back.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint entry UI.

## 6. Result And History

- [x] Implementasi Review/Result screen.
- [x] Implementasi breakdown per peserta.
- [x] Implementasi expandable item detail.
- [x] Implementasi Copy Summary.
- [x] Implementasi Save bill ke history.
- [x] Implementasi History Detail read-only.
- [x] Tambahkan halaman Riwayat penuh.
- [x] Batasi preview Riwayat di halaman Bill maksimal 2 item.
- [x] Ganti counter kanan atas card Riwayat menjadi `Lihat semua`.
- [x] Jadikan `Lihat semua` pindah ke tab Riwayat.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint result/history.

## 7. Settings And Localization

- [x] Tambahkan enum `AppLanguage` dengan nilai `id` dan `en`.
- [x] Simpan pilihan bahasa di app state.
- [x] Tambahkan controller action untuk mengganti bahasa.
- [x] Buat helper teks lokal `SplitStrings`.
- [x] Pastikan default bahasa tetap Indonesia.
- [x] Tambahkan section Language di Settings.
- [x] Tambahkan segmented control `Indonesia` / `English`.
- [x] Pastikan pilihan langsung mengubah teks aplikasi.
- [x] Lokalkan teks Home, navigation, Settings, wizard, Result, History Detail, snackbar, dialog, empty state, warning, dan validation error.
- [x] Pendekkan copy yang panjang menjadi satu kalimat pendek.
- [x] Uji acceptance otomatis flow Indonesia: Home -> New Bill -> Result.
- [x] Uji acceptance otomatis flow English: Home -> New Bill -> Result.
- [x] Pastikan Settings tetap bisa mengganti theme dan language.
- [x] Pastikan Copy Summary mengikuti bahasa aktif.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint localization.

## 8. UI Polish And Acceptance

- [x] Audit spacing konsisten.
- [x] Audit data yang ditampilkan tidak duplikatif.
- [x] Audit layout long item name dan 8+ participants.
- [x] Audit small width behavior 320-359dp.
- [x] Audit light/dark Result.
- [x] Pastikan Home tidak punya card `Split Rata`, `Custom`, atau `Bill Baru`.
- [x] Pastikan FAB `+` di kanan bawah membuka pencatatan bill.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [ ] Jalankan `flutter build apk --debug` bila Android SDK tersedia.
- [ ] Lakukan visual check di device/emulator untuk mobile, light/dark, dan persistence restart.

## 9. Next Simple Feature Backlog

Prioritas yang disarankan: mulai dari fitur yang kecil, terasa langsung manfaatnya, dan tidak mengubah core kalkulasi.

### 9.1 Delete Saved Bill

- [x] Tambahkan action delete di `HistoryDetailPage`.
- [x] Tambahkan action delete pada item list di tab Riwayat bila layout tetap rapi.
- [x] Tambahkan confirmation dialog sebelum hapus.
- [x] Tambahkan repository/controller method delete bill dengan transaction atau cascade yang aman.
- [x] Refresh list history setelah delete.
- [x] Tambahkan test delete history bila environment mendukung.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint delete saved bill.

### 9.2 Share Split Result

- [x] Tambahkan dependency share native bila diperlukan dan tersedia lokal.
  Catatan: `share_plus` tidak tersedia di Pub cache lokal dan network restricted, jadi dependency native tidak ditambahkan.
- [x] Tambahkan tombol share di Result dan History Detail.
- [x] Reuse format ringkasan dari Copy Summary agar output konsisten.
- [x] Pastikan fallback copy tetap tersedia bila share plugin tidak tersedia.
- [x] Tambahkan test untuk formatter/share text.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint share result.

### 9.3 Search History

- [x] Tambahkan search field di tab Riwayat.
- [x] Filter berdasarkan judul bill, mode, dan jumlah peserta.
- [x] Pastikan empty state search berbeda dari empty state belum ada bill.
- [x] Jaga search state tetap lokal di halaman Riwayat.
- [x] Tambahkan widget test pencarian sederhana.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint search history.

### 9.4 Filter History By Mode

- [x] Tambahkan filter chip atau segmented control: Semua, Split Rata, Per Item, Custom.
- [x] Kombinasikan filter dengan search bila 9.3 sudah selesai.
- [x] Pastikan filter memakai mode yang tersimpan di `SavedBillSummary`.
- [x] Tambahkan widget test filter mode.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint filter history.

### 9.5 Duplicate Bill From History

- [x] Tambahkan action `Pakai lagi` dari History Detail.
- [x] Buat draft baru dari bill lama dengan tanggal sekarang.
- [x] Pertahankan peserta, item, assignment, charges, dan mode.
- [x] Pastikan saved bill lama tidak ikut berubah.
- [x] Tambahkan test controller untuk duplicate draft.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint duplicate bill.

### 9.6 Paid Checklist

- [x] Tambahkan status lokal sudah bayar/belum bayar per peserta pada saved bill.
- [x] Tentukan schema/migration SQLite yang tidak merusak snapshot lama.
- [x] Tampilkan checklist di Result setelah save atau di History Detail.
- [x] Pastikan checklist tidak mengubah hasil kalkulasi.
- [x] Tambahkan test persistence/checklist bila environment mendukung.
- [x] Jalankan `flutter analyze` dan `flutter test --concurrency=1`.
- [x] Commit dan push checkpoint paid checklist.

## 10. Final Validation Checklist

- [x] `flutter analyze` clean pada checkpoint terakhir.
- [x] `flutter test --concurrency=1` pass pada checkpoint terakhir.
- [ ] `flutter build apk --debug` pass bila SDK Android tersedia.
- [ ] Visual acceptance device/emulator untuk navigasi, FAB, Riwayat, Settings, dan New Bill.
- [ ] Persistence restart validation untuk saved bill.
