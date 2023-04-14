# Used Cars Database
Project ini adalah project desain relational database berbasis PostgreSQL untuk sebuah website jual-beli mobil bekas.


# Background
Di website mobil bekas ini, user yang mendaftarkan diri sebagai seller dapat menawarkan produk berupa mobil bekas dalam bentuk iklan dan user yang mendaftarkan diri sebagai buyer dapat mencari produk berdasarkan beberapa kategori.


# Feature & Constraints
1. Setiap seller dapat menawarkan satu atau lebih produk mobil bekas.
2. Sebelum menjual mobil, seller harus melengkapi data dirinya terlebih dahulu, seperti nama, kontak, dan domisili lokasi.
3. Seller menawarkan produknya melalui iklan yang akan ditampilkan oleh website.
4. Iklan di website berisi judul, detail informasi produk yang ditawarkan, serta kontak penjual.
5. Beberapa informasi yang harus ditulis dalam iklan adalah sebagai berikut:
- merek
- model
- jenis body
- tipe
- tahun pembuatan
- deskripsi lain seperti warna atau jarak yang telah ditempuh boleh ditambahkan sesuai kebutuhan.
6. Setiap buyer bisa mencari mobil yang ditawarkan berdasarkan lokasi seller, merek, dan jenis body mobil.
7. Jika calon buyer tertarik, ia dapat mengajukan penawaran (bid) jika seller mengizinkan fitur tawar.


# Designing the Database

1. Mission Statement

Untuk memenuhi kebutuhan dari website mobil bekas ini, ada tiga hal utama yang dicakup dalam desain database:
a. 