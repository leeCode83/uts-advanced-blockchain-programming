# Simple Marketplace Smart Contract

## a) Deskripsi Singkat Kontrak
[cite_start]Kontrak pintar ini, bernama `Marketplace.sol`, berfungsi sebagai implementasi dasar dari *Decentralized Marketplace* sederhana di jaringan Ethereum. [cite: 156] [cite_start]Tujuan utamanya adalah untuk memfasilitasi penjual menambahkan produk (`addProduct`) dan pembeli membeli produk (`buyProduct`) menggunakan ETH. [cite: 156]

Fitur inti:
1.  **Pendaftaran Produk:** Penjual dapat mendaftarkan produk dengan detail (nama, harga, stok).
2.  [cite_start]**Pembelian:** Pembeli mengirimkan ETH yang setara dengan harga produk. [cite: 156]
3.  [cite_start]**Transfer Dana Otomatis:** Setelah pembelian sukses, ETH yang dibayarkan akan langsung dikirimkan ke alamat penjual. [cite: 157, 191]
4.  [cite_start]**Penandaan Terjual:** Jika stok produk habis, status `isSold` akan diperbarui menjadi `true`. [cite: 157, 190]

[cite_start]**Catatan:** Sesuai ketentuan, kontrak ini tidak mencakup fitur *front-end*, *rating*, maupun fungsi penarikan saldo terpisah (`withdraw`) untuk menjaga kesederhanaan. [cite: 162]

## b) Cara Menjalankan dan Pengujian di Remix IDE
[cite_start]Berikut adalah langkah-langkah untuk *deploy* dan menguji fungsionalitas utama kontrak ini menggunakan Remix IDE: [cite: 174]

1.  **Akses Remix:** Buka Remix IDE (https://remix.ethereum.org/).
2.  **Muat Kontrak:** Buat file baru bernama `Marketplace.sol` dan tempelkan kode kontrak.
3.  **Kompilasi:** Pada tab "Solidity Compiler", pastikan versi *compiler* sesuai dengan *pragma* (`^0.8.30`) dan kompilasi kontrak.
4.  **Deployment:**
    * Pilih tab "Deploy & Run Transactions".
    * Atur *Environment* ke **"Javascript VM"** (untuk pengujian cepat di browser).
    * Pilih kontrak `Marketplace` dan klik **"Deploy"**. (Kontrak akan ter-deploy oleh **Akun 1**, yang bertindak sebagai *owner*).

5.  [cite_start]**Pengujian `addProduct` (Simulasi Penjual - Akun 2):** [cite: 168]
    * Ubah alamat di *Account* menjadi **Akun 2**.
    * Panggil fungsi `addProduct` dengan nilai contoh:
        * `_name`: "Laptop Gaming"
        * `_price`: 1000000000000000000 (1 Ether dalam Wei)
        * `_stock`: 2
    * Klik **"transact"**. (Ambil *screenshot* pemanggilan `addProduct`).
    * Periksa *log* transaksi di konsol untuk melihat *event* `ProductAdded`.

6.  [cite_start]**Pengujian `buyProduct` (Simulasi Pembeli - Akun 3):** [cite: 169, 170]
    * Ubah alamat di *Account* menjadi **Akun 3**.
    * Di kolom **Value**, masukkan nilai yang sama dengan harga produk (misalnya: **1 Ether**).
    * Panggil fungsi `buyProduct` dengan *ID produk* yang baru dibuat (misalnya: `1`).
    * Klik **"transact"**. (Ambil *screenshot* transaksi `buy` sukses dan *event/log* `ProductPurchased`).

7.  [cite_start]**Verifikasi Status Produk (Pembacaan State):** [cite: 171]
    * Panggil fungsi `getProductDetails(1)` atau panggil fungsi *getter* **`products(1)`**.
    * Verifikasi bahwa nilai *stock* telah berkurang menjadi 1. (Ambil *screenshot* pembacaan *state* `products(id)`).

## c) Asumsi yang Digunakan
[cite_start]Implementasi kontrak ini dibuat dengan asumsi dan penyederhanaan berikut: [cite: 175]

1.  **Validasi Penjual Sederhana:** Setiap alamat Ethereum yang memanggil fungsi `addProduct` secara otomatis dianggap sebagai penjual yang valid untuk produk tersebut. Tidak ada mekanisme registrasi penjual yang kompleks atau kontrol akses *owner* yang diterapkan pada fungsi `addProduct`.
2.  **Mekanisme Transaksi:** Diasumsikan bahwa jumlah ETH yang dikirim (`msg.value`) oleh pembeli harus **sama atau lebih besar** dari harga produk. Jika lebih besar, sisa kelebihan dana tersebut akan tetap ditransfer ke penjual (bersama dengan dana yang sesuai harga produk), karena seluruh `msg.value` yang diterima dalam fungsi `payable` akan diteruskan.
3.  **Transfer Dana:** Transfer dana kepada penjual menggunakan metode `call` Solidity, yang merupakan metode transfer paling direkomendasikan dan fleksibel (meskipun berisiko). Diasumsikan transfer ini akan selalu berhasil kecuali ada masalah *gas* atau batasan pada kontrak penerima.
4.  **Jenis Produk:** Kontrak ini hanya mengurus produk yang berwujud atau digital dengan konsep stok yang dapat berkurang. Jika stok produk (`stock`) mencapai nol, produk secara otomatis ditandai sebagai terjual (`isSold = true`), mencegah pembelian lebih lanjut.
