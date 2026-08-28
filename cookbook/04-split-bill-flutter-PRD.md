# PRD — Split: Split Bill Calculator

**Platform:** Mobile — Flutter  
**Persistence:** `sqflite` / SQLite lokal  
**Mode:** Offline-first, single-device calculation  
**Prototype target:** Lovable

## 1. Ringkasan produk

Split adalah kalkulator pembagian tagihan untuk makan atau aktivitas bersama. Pengguna membuat bill, menambahkan orang dan item, menentukan siapa mengonsumsi apa, lalu aplikasi menghitung share setiap orang termasuk tax, service, discount, dan rounding.

## 2. Tujuan

- Membuat pembagian tagihan item-based yang biasanya rumit menjadi jelas.
- Memastikan total hasil pembagian selalu sama dengan grand total bill.
- Dapat digunakan tanpa akun dan tanpa internet.
- Menjadi project portfolio kecil yang menonjolkan interaction design dan calculation logic.

## 3. Scope MVP

Termasuk: bill manual, participants, items, qty, assignment item, equal/item/custom split, tax, service charge, discount, rounding adjustment, result, history lokal.

Tidak termasuk: OCR receipt, payment transfer, contact sync, collaborative multi-phone editing, cloud sync, restaurant integration.

## 4. Navigasi

Karena flow bersifat task-based, gunakan struktur sederhana:

- Home / History
- `New Bill` sebagai CTA utama
- Settings ringan dari Home

Tidak perlu 5-tab navigation.

## 5. Core flow

`New Bill → title/date → add people → add items → assign items → charges/discount → review → result`

Quick route tersedia untuk `Split Equally` tanpa memasukkan item satu per satu.

## 6. Screen requirements

### Home

- Hero `Split a new bill`.
- Recent Bills dengan date, participants count, total.
- Empty state memberi dua pilihan: Item Split atau Equal Split.

### People

- Add participant via first name/nickname.
- Avatar berbasis initial + generated color.
- Edit/remove sebelum calculation finalized.

### Items

- Item name, quantity, total item price atau unit price (UI harus menyatakan mode dengan jelas).
- Stepper qty.
- Tap item membuka participant assignment.

### Assign Item

Contoh `Pizza Rp180.000, qty 2`.

- Select one/multiple people.
- Default membagi nilai item secara sama ke selected people.
- `Select All` tersedia.
- Advanced custom shares opsional di MVP jika UI tetap sederhana.

### Charges

- Subtotal read-only.
- Tax: percentage atau fixed.
- Service: percentage atau fixed.
- Discount: fixed atau percentage.
- Semua charge memperbarui preview total secara langsung.

### Result

- Grand total di atas.
- Per-person card: base items, share tax/service, discount, rounding, amount due.
- Expand untuk melihat detail item.
- `Copy Summary` menghasilkan teks ke clipboard secara lokal.
- Save bill ke history.

### History Detail

- View-only snapshot hasil lama.
- Duplicate bill menjadi bill baru opsional.

## 7. Calculation rules

- Gunakan integer minor unit/satuan rupiah untuk menghindari floating-point money errors.
- Total item dibagi ke participant terpilih; remainder 1 rupiah didistribusikan deterministik agar jumlah share = item total.
- Tax/service percentage dihitung dari subtotal sesuai rule app dan dialokasikan proporsional terhadap base share masing-masing orang.
- Discount tidak boleh menghasilkan grand total negatif.
- Rounding residual dibagikan deterministik dan ditampilkan bila material.
- Invariant wajib: `sum(person.amount_due) == bill.grand_total`.
- Participant yang sudah memiliki assignment tidak boleh dihapus tanpa warning dan reassignment/cleanup.

## 8. Split modes

### Equal Split
Grand total dibagi rata ke seluruh participant.

### By Items
Item dialokasikan ke participant, lalu tax/service/discount dibagi proporsional.

### Custom Amount
User menentukan jumlah per orang; UI menunjukkan remaining amount sampai menjadi nol.

## 9. Model data lokal

### bills
`id, title?, occurred_at, split_mode, tax_type?, tax_value?, service_type?, service_value?, discount_type?, discount_value?, subtotal, grand_total, created_at, updated_at`

### participants
`id, bill_id, name, color_seed`

### bill_items
`id, bill_id, name, quantity, total_amount`

### item_participants
`item_id, participant_id, share_weight`

### settlement_results
`id, bill_id, participant_id, base_amount, charges_amount, discount_amount, rounding_amount, amount_due`

## 10. Arahan UI/UX Lovable

Karakter: playful tetapi tetap presisi. Gunakan neutral light/dark surfaces dengan accent coral/orange atau violet. Warna participant menjadi alat identifikasi, bukan dekorasi.

- Gunakan step indicator pada New Bill, tetapi jangan membuat wizard terasa panjang.
- Total selalu mudah ditemukan.
- Assignment harus visual: initials/chips dengan selected state sangat jelas.
- Back tidak boleh membuang data step sebelumnya.
- Konfirmasi hanya saat meninggalkan bill dengan perubahan signifikan yang belum disimpan.

### Adaptive mobile

- Small 320–359dp: participant chips wrap; monetary summary stack.
- Medium 360–399dp: baseline.
- Large ≥400dp: result cards lebih lega, tetap single-column.
- Portrait-first dan keypad aware.

## 11. State wajib

No history, bill without items, no participants, unassigned items, incomplete custom split, rounding case, many participants (8+), long item name, light/dark Result.

## 12. Acceptance criteria

- User dapat menyelesaikan equal split dan item split sepenuhnya offline.
- Hasil setiap bill memenuhi invariant total.
- Tax/service/discount dan rounding terlihat transparan pada Review/Result.
- Bill yang disimpan dapat dibuka kembali setelah restart.
- Data entry tidak hilang saat berpindah antar-step sebelum bill selesai.

## 13. V2

Receipt OCR, share result as image, saved friend groups, multiple currencies, debt/settlement tracking, collaborative sessions, dan cloud backup.

