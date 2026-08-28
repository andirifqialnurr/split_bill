# Split Bill PRD

## Ringkasan

Split Bill adalah aplikasi Flutter mobile offline-first untuk membagi tagihan bersama. Aplikasi membantu pengguna membuat bill, menambahkan peserta dan item, memilih metode pembagian, lalu menghitung total yang harus dibayar setiap orang dengan tax, service charge, discount, dan rounding yang transparan.

## Scope Wajib

Fokus tahap ini adalah membuat aplikasi jadi dan dapat dipakai end-to-end secara lokal.

- Membuat bill baru secara manual.
- Menambahkan, mengedit, dan menghapus peserta sebelum bill disimpan.
- Menambahkan item dengan nama, kuantitas, dan total harga.
- Assign item ke satu atau beberapa peserta.
- Mode pembagian `Equal Split`, `By Items`, dan `Custom Amount`.
- Tax, service charge, dan discount dalam bentuk fixed amount atau percentage.
- Perhitungan uang menggunakan integer rupiah.
- Result per peserta dengan breakdown yang jelas.
- Copy summary ke clipboard.
- Simpan bill ke SQLite lokal menggunakan `sqflite`.
- Home/history lokal dengan detail bill tersimpan.
- Theme light dan dark.

## Di Luar Scope

- OCR receipt.
- Transfer pembayaran.
- Contact sync.
- Multi-device collaboration.
- Cloud sync atau backup cloud.
- Integrasi restoran.
- Multi-currency.

## Navigasi

Aplikasi memakai flow yang jelas dan pendek.

- Home berisi CTA `New Bill`, quick action `Equal Split`, dan history bill.
- New Bill menggunakan step flow: detail, people, items, charges, review/result.
- Settings ringan untuk theme mode.
- Bottom navigation hanya dipakai jika dibutuhkan untuk Home dan Settings, dengan bentuk floating.

## Flow Utama

1. Pengguna membuka Home.
2. Pengguna memilih `New Bill`.
3. Pengguna memilih mode split.
4. Pengguna mengisi detail bill dan peserta.
5. Untuk `By Items`, pengguna mengisi item dan assignment.
6. Untuk `Equal Split`, pengguna mengisi total bill.
7. Untuk `Custom Amount`, pengguna mengisi total bill dan amount per peserta sampai sisa nol.
8. Pengguna mengisi tax, service, discount bila ada.
9. Pengguna melihat review/result.
10. Pengguna menyalin summary atau menyimpan bill ke history.

## Kebutuhan Screen

### Home

- Header ringkas dengan total history dan CTA utama.
- Empty state hanya menampilkan action yang relevan.
- Recent bills menampilkan judul, tanggal, jumlah peserta, dan grand total.
- Tidak ada duplikasi informasi total yang sama dalam satu area.

### New Bill

- Step indicator compact.
- Form title/date/mode.
- Data yang sudah diisi tidak hilang ketika berpindah step.
- Back hanya membatalkan setelah konfirmasi jika ada perubahan berarti.

### People

- Input nama panggilan.
- Avatar initial dengan warna deterministik.
- List peserta rapi dengan action edit/remove.
- Peserta yang sudah punya assignment tidak dapat dihapus tanpa cleanup.

### Items

- Input nama item, quantity, dan total harga item.
- Quantity memakai stepper.
- Item membuka assignment peserta.
- Item yang belum assigned terlihat jelas tetapi tidak berisik.

### Charges

- Subtotal read-only.
- Tax fixed/percentage.
- Service fixed/percentage.
- Discount fixed/percentage.
- Preview grand total berubah langsung.

### Result

- Grand total sebagai fokus utama.
- Card per peserta: base items, tax/service, discount, rounding, amount due.
- Detail item expandable.
- Copy summary.
- Save bill.

### History Detail

- Snapshot read-only dari bill tersimpan.
- Menampilkan breakdown yang sama dengan Result.

## Aturan Perhitungan

- Semua nominal disimpan dan dihitung sebagai integer rupiah.
- `sum(person.amountDue) == bill.grandTotal` wajib selalu benar.
- Remainder pembagian rupiah didistribusikan deterministik berdasarkan urutan peserta.
- Tax dan service percentage dihitung dari subtotal lalu dialokasikan proporsional terhadap base share.
- Discount tidak boleh membuat grand total negatif.
- Custom Amount harus menunjukkan remaining amount dan hanya valid saat remaining nol.

## Acceptance Criteria

- App dapat menyelesaikan Equal Split, By Items, dan Custom Amount secara offline.
- Bill tersimpan dapat dibuka kembali setelah app restart.
- Perhitungan memenuhi invariant total.
- UI light/dark konsisten, modern, curved, dan rapi.
- Tidak ada informasi penting yang ditampilkan berulang tanpa alasan.
- Tidak ada komponen dengan layout konten yang bertabrakan atau jarak inkonsisten.
- Semua task wajib di `TODO.md` selesai dan tervalidasi.
