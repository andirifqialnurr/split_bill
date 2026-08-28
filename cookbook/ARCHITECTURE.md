# Split Bill Architecture

## Prinsip

- Offline-first, single-device.
- SQLite lokal melalui `sqflite`.
- Perhitungan uang murni di domain layer, bebas dari widget dan database.
- UI membaca state yang sudah terstruktur, bukan menghitung ulang di banyak tempat.
- Snapshot bill lama immutable setelah disimpan.

## Struktur Folder

```text
lib/
  main.dart
  app/
    split_bill_app.dart
    split_bill_controller.dart
    split_bill_state.dart
  core/
    money.dart
    date_formatters.dart
  data/
    split_bill_database.dart
    split_bill_repository.dart
    split_bill_mappers.dart
  domain/
    split_bill_models.dart
    split_bill_calculator.dart
  features/
    home/
      home_page.dart
      history_detail_page.dart
    bill/
      new_bill_page.dart
      bill_steps.dart
      result_page.dart
    settings/
      settings_page.dart
  ui/
    split_theme.dart
    split_tokens.dart
    split_components.dart
```

## Layer

### UI Layer

Berisi widget, page, layout, dan interaksi user. UI hanya memanggil controller dan menampilkan state. UI tidak menulis SQL langsung dan tidak mengandung rumus pembagian.

### App State Layer

`SplitBillController` mengelola:

- daftar history,
- draft bill aktif,
- theme mode,
- navigasi step,
- action seperti add participant, add item, assign item, save bill.

### Domain Layer

`SplitBillCalculator` menerima draft bill dan menghasilkan `BillCalculation`. Layer ini bertanggung jawab untuk:

- equal split,
- item split,
- custom amount,
- tax/service/discount,
- rounding residual,
- invariant total.

### Data Layer

`SplitBillDatabase` membuat dan membuka database sqflite. `SplitBillRepository` menyimpan dan membaca snapshot bill lengkap menggunakan transaction.

## State Flow

```text
Widget action
  -> SplitBillController
  -> mutate DraftBill
  -> SplitBillCalculator
  -> SplitBillState updated
  -> UI rebuild
```

Saat save:

```text
SplitBillController.saveCurrentBill
  -> SplitBillCalculator.calculate
  -> SplitBillRepository.saveBillSnapshot
  -> sqflite transaction
  -> reload history
```

## Navigation

Home dan Settings dapat berada dalam shell dengan floating bottom nav. New Bill dan History Detail dibuka sebagai pushed page agar flow task tetap jelas.

## Validation Strategy

- Unit test calculator untuk invariant dan edge cases.
- Widget test smoke untuk Home dan New Bill.
- Repository test bila sqflite test environment tersedia.
- Manual visual check tetap dibutuhkan untuk layout mobile dan light/dark.

## Error Handling

- Validasi form dilakukan sebelum next step.
- Empty participant, empty item, unassigned item, dan custom remaining tidak nol harus punya feedback ringkas.
- Database error ditampilkan sebagai snackbar singkat dengan action retry bila relevan.
