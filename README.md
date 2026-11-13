# AeroLog — RC Flight Weather & Logbook

**AeroLog** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pilot *aeromodelling* / pesawat RC (*Fixed-Wing*, *Glider*, dan *Parkflyer*) memantau kelayakan cuaca dan kecepatan angin lokasi terbang secara *real-time* melalui integrasi **Public REST API (Open-Meteo)** serta mencatat jurnal evaluasi uji terbang (*Flight Logbook*) ke dalam database **Supabase PostgreSQL**.

---

## Identitas Mahasiswa
* **Nama:** Liam Arta Febrio
* **NIM:** 2415051087
* **Program Studi:** Pendidikan Teknik Informatika
* **Mata Kuliah:** Pemrograman Mobile (Project UTS)
* **Dosen Pengampu:** Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom

---

## Daftar Fitur Utama
1. **Live Weather Monitoring (REST API GET):** Mengambil data kecepatan angin (`km/h`), arah mata angin (`°`), dan suhu udara (`°C`) secara *real-time* di berbagai titik lokasi terbang RC di Bali.
2. **Katalog Lokasi Terbang Interaktif:** Mendukung pencarian lokasi (*search*), filter berdasarkan status kelayakan terbang (*Optimal*, *Waspada Angin*, *Favorit*), serta pengurutan kecepatan angin (*sort ascending/descending*).
3. **Shared Application State (Provider):** Fitur *Bookmark / Favorite Spot* dan sinkronisasi data antar-screen menggunakan `Provider` & `ChangeNotifier`.
4. **Pre-Flight Safety Checklist (Fitur Kreativitas):** Daftar periksa keselamatan wahana interaktif dengan *progress indicator* sebelum pilot memulai pencatatan penerbangan.
5. **Flight Logbook CRUD (Supabase Database):** Operasi **Create, Read, Update, dan Delete** (dilengkapi *Confirmation Dialog* saat menghapus data) untuk mencatat lokasi terbang, spesifikasi wahana RC, durasi terbang, *rating* performa (1–5 bintang), dan catatan evaluasi.
6. **Responsive Layout (Compact & Wide Mode):** Otomatis menyesuaikan tata letak dari `BottomNavigationBar` + `ListView` pada layar *compact* (`< 600px`) menjadi `NavigationRail` + `GridView` multi-kolom pada layar *wide/expanded* (`>= 600px`).
7. **Complete State Handling:** Menangani *Loading State*, *Error State* (dengan tombol *Retry*), *Empty State*, serta validasi input pada `Form`.

---

## Tech Stack
* **Framework & Bahasa:** Flutter SDK & Dart (Null Safety)
* **State Management:** `provider` (`ChangeNotifier`, `MultiProvider`, `Consumer`)
* **Networking:** `http` (REST API Integration)
* **Backend & Database:** `supabase_flutter` (Supabase PostgreSQL)
* **Utilities:** `intl` (Date Formatting)

---

## REST API yang Digunakan
* **Penyedia API:** [Open-Meteo Weather Forecast API](https://open-meteo.com/)
* **Method:** `GET`
* **Endpoint:**
  ```text
  [https://api.open-meteo.com/v1/forecast?latitude=](https://api.open-meteo.com/v1/forecast?latitude=){lat}&longitude={lon}&current=temperature_2m,wind_speed_10m,wind_direction_10m&wind_speed_unit=kmh