# Split Bill SQLite Schema

Database lokal memakai `sqflite`. Semua uang memakai integer rupiah.

## Database

- Name: `split_bill.db`
- Version awal: `1`
- Foreign key: aktif saat `onConfigure`

## Enum

### split_mode

- `equal`
- `items`
- `custom`

### charge_type

- `none`
- `fixed`
- `percentage`

## Tabel `bills`

| Column | Type | Constraint | Notes |
| --- | --- | --- | --- |
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Local id |
| title | TEXT | NULL | Optional title |
| occurred_at | TEXT | NOT NULL | ISO-8601 date |
| split_mode | TEXT | NOT NULL | `equal`, `items`, `custom` |
| equal_total_amount | INTEGER | NOT NULL DEFAULT 0 | Dipakai untuk equal/custom |
| tax_type | TEXT | NOT NULL DEFAULT 'none' | `none`, `fixed`, `percentage` |
| tax_value | INTEGER | NOT NULL DEFAULT 0 | Fixed rupiah atau basis point percentage |
| service_type | TEXT | NOT NULL DEFAULT 'none' | `none`, `fixed`, `percentage` |
| service_value | INTEGER | NOT NULL DEFAULT 0 | Fixed rupiah atau basis point percentage |
| discount_type | TEXT | NOT NULL DEFAULT 'none' | `none`, `fixed`, `percentage` |
| discount_value | INTEGER | NOT NULL DEFAULT 0 | Fixed rupiah atau basis point percentage |
| subtotal | INTEGER | NOT NULL DEFAULT 0 | Sebelum charges/discount |
| tax_amount | INTEGER | NOT NULL DEFAULT 0 | Hasil kalkulasi |
| service_amount | INTEGER | NOT NULL DEFAULT 0 | Hasil kalkulasi |
| discount_amount | INTEGER | NOT NULL DEFAULT 0 | Hasil kalkulasi |
| grand_total | INTEGER | NOT NULL DEFAULT 0 | Setelah charges/discount |
| created_at | TEXT | NOT NULL | ISO-8601 datetime |
| updated_at | TEXT | NOT NULL | ISO-8601 datetime |

## Tabel `participants`

| Column | Type | Constraint | Notes |
| --- | --- | --- | --- |
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Local id |
| bill_id | INTEGER | NOT NULL REFERENCES bills(id) ON DELETE CASCADE | Parent bill |
| name | TEXT | NOT NULL | Nickname |
| color_seed | INTEGER | NOT NULL | Deterministic avatar color |
| sort_order | INTEGER | NOT NULL DEFAULT 0 | Urutan stabil |

## Tabel `bill_items`

| Column | Type | Constraint | Notes |
| --- | --- | --- | --- |
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Local id |
| bill_id | INTEGER | NOT NULL REFERENCES bills(id) ON DELETE CASCADE | Parent bill |
| name | TEXT | NOT NULL | Nama item |
| quantity | INTEGER | NOT NULL DEFAULT 1 | Minimal 1 |
| total_amount | INTEGER | NOT NULL DEFAULT 0 | Total item, bukan unit price |
| sort_order | INTEGER | NOT NULL DEFAULT 0 | Urutan stabil |

## Tabel `item_participants`

| Column | Type | Constraint | Notes |
| --- | --- | --- | --- |
| item_id | INTEGER | NOT NULL REFERENCES bill_items(id) ON DELETE CASCADE | Parent item |
| participant_id | INTEGER | NOT NULL REFERENCES participants(id) ON DELETE CASCADE | Assigned participant |
| share_weight | INTEGER | NOT NULL DEFAULT 1 | Untuk custom item weight |

Primary key: `(item_id, participant_id)`.

## Tabel `custom_shares`

| Column | Type | Constraint | Notes |
| --- | --- | --- | --- |
| bill_id | INTEGER | NOT NULL REFERENCES bills(id) ON DELETE CASCADE | Parent bill |
| participant_id | INTEGER | NOT NULL REFERENCES participants(id) ON DELETE CASCADE | Participant |
| amount | INTEGER | NOT NULL DEFAULT 0 | Amount manual |

Primary key: `(bill_id, participant_id)`.

## Tabel `settlement_results`

| Column | Type | Constraint | Notes |
| --- | --- | --- | --- |
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Local id |
| bill_id | INTEGER | NOT NULL REFERENCES bills(id) ON DELETE CASCADE | Parent bill |
| participant_id | INTEGER | NOT NULL REFERENCES participants(id) ON DELETE CASCADE | Participant |
| base_amount | INTEGER | NOT NULL DEFAULT 0 | Share item/equal/custom sebelum charges |
| charges_amount | INTEGER | NOT NULL DEFAULT 0 | Tax + service share |
| discount_amount | INTEGER | NOT NULL DEFAULT 0 | Discount share |
| rounding_amount | INTEGER | NOT NULL DEFAULT 0 | Adjustment residual |
| amount_due | INTEGER | NOT NULL DEFAULT 0 | Final due |

## Index

- `idx_participants_bill_id` on `participants(bill_id)`
- `idx_bill_items_bill_id` on `bill_items(bill_id)`
- `idx_item_participants_participant_id` on `item_participants(participant_id)`
- `idx_settlement_results_bill_id` on `settlement_results(bill_id)`

## Persistence Rule

Draft bill boleh hidup di memory selama flow berjalan. Saat `Save bill`, app menyimpan snapshot lengkap: bill, participants, items, assignments, custom shares, dan settlement results dalam satu transaction.
