# Split Bill Design System

## Karakter Visual

Modern, curved, ringan, dan presisi. App harus terasa cocok untuk momen makan bersama: hangat, sosial, tetapi tetap jelas untuk angka.

## Warna

Palette tidak boleh didominasi satu hue. Coral dipakai sebagai accent utama, mint sebagai aksen sekunder, dan ink/cream sebagai surface netral.

### Light

- Background: `#FFF8F3`
- Surface: `#FFFFFF`
- Surface elevated: `#FFF1E7`
- Primary coral: `#FF6B4A`
- Secondary mint: `#2DBE9F`
- Accent violet: `#7C5CFF`
- Text primary: `#1D1B20`
- Text secondary: `#6F625D`
- Border: `#EADDD4`
- Success: `#178F65`
- Warning: `#B7791F`
- Danger: `#D64545`

### Dark

- Background: `#171313`
- Surface: `#221C1C`
- Surface elevated: `#302727`
- Primary coral: `#FF8A6C`
- Secondary mint: `#49D6B6`
- Accent violet: `#A18CFF`
- Text primary: `#FFF8F3`
- Text secondary: `#CDBEB7`
- Border: `#4A3D3A`
- Success: `#54D39A`
- Warning: `#F2B84B`
- Danger: `#FF7777`

## Typography

- Gunakan Material default font agar offline-safe.
- Heading memakai weight 700.
- Body memakai weight 400-500.
- Nominal uang memakai tabular figures bila memungkinkan.
- Tidak memakai font size berbasis viewport width.
- Letter spacing 0.

## Radius

- Small control: 14
- Input/button/chip: 18
- Sheet/card utama: 24
- Floating nav: 28

## Spacing

Gunakan grid 4dp.

- `xs`: 4
- `sm`: 8
- `md`: 12
- `lg`: 16
- `xl`: 24
- `xxl`: 32

Komponen dalam satu area harus memakai spacing konsisten. Hindari jarak acak seperti 13, 19, 27.

## Component Rules

- Jangan tampilkan informasi yang sama dua kali dalam satu viewport kecuali ada konteks berbeda yang jelas.
- Jangan menampilkan ID teknis lokal kepada user.
- Card hanya untuk item berulang, result per peserta, history row, dan form group penting.
- Jangan membuat card di dalam card.
- Konten card harus punya hierarki jelas: title, supporting text, action.
- Nominal utama hanya satu per area.
- Long text harus wrap atau ellipsis sesuai konteks.
- Button icon dipakai untuk action kecil, text button untuk action eksplisit.

## Floating Bottom Nav

Jika dipakai:

- Posisi floating di bawah dengan margin horizontal 20.
- Background memakai surface elevated.
- Radius 28.
- Shadow halus.
- Maksimal 3 item.
- Label singkat.
- Tidak dipakai di dalam New Bill flow agar fokus.

## Light/Dark

Theme mode:

- System
- Light
- Dark

Semua surface, border, chip, dan bottom nav harus membaca `ColorScheme`. Jangan hardcode warna dalam page kecuali melalui token.

## Responsive Mobile

- 320-359dp: chips wrap, summary stack, button full-width bila perlu.
- 360-399dp: baseline single-column.
- 400dp ke atas: spacing lebih lega, tetap single-column.
- Keyboard tidak boleh menutupi action utama form.
