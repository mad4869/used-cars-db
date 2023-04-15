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

**1. Mission Statement**

<!-- Untuk memenuhi kebutuhan dari website mobil bekas ini, ada tiga hal utama yang dicakup dalam desain database: <br> -->
<!-- a. Mengelola user yang mendaftarkan diri pada website sebagai seller maupun buyer. <br>
b. Mengelola produk yang ditawarkan seller melalui iklan pada marketplace. <br>
c. Mengelola penawaran harga yang disubmit buyer. -->
![Mission statement untuk database design website mobil bekas](https://i.imgur.com/tYVyQGL.jpg)

**2. Creating Table Structures**

- Determine the subjects <br>
<!-- a. seller: tabel yang menyimpan data penjual <br>
b. buyer: tabel yang menyimpan data pembeli <br>
c. seller_address: tabel yang menyimpan detail alamat penjual <br>
d. buyer_address: tabel yang menyimpan detail alamat pembeli <br>
e. city: tabel yang menyimpan detail kota <br>
f. ads: tabel yang menyimpan informasi tentang iklan yang ditayangkan penjual <br>
g. products: tabel yang menyimpan informasi tentang produk yang ditawarkan via iklan <br>
i. bids: tabel yang menyimpan informasi tentang penawaran harga dari pembeli -->
![Table structures untuk database website mobil bekas](https://i.imgur.com/wFobmuI.jpg)

- Creating Field Name and Data Type

![Field name dan data type untuk tiap tabel](https://i.imgur.com/K5cpgsr.jpg)

- Determine Candidate Keys

![Candidate keys untuk tiap tabel](https://i.imgur.com/0LAOEzG.jpg)

- Determine Primary Keys

![Primary keys untuk tiap tabel](https://i.imgur.com/0T9gkU2.jpg)

**3. Determine Table Relationships**

![Relationship antar tabel](https://i.imgur.com/ayNtUee.jpg)

**4. Determine Business Rule**

![Business rule untuk tiap tabel](https://i.imgur.com/jWK3iZH.jpg)

**5. Entity Relationship Diagram**

![Entity Relationship Diagram](https://i.imgur.com/GYIfzDV.jpg)

# Implementing the Design
Tabel dibuat di dalam database PostgreSQL dengan menggunakan syntax Data Definition Language (DDL) berikut:
```
    -- TABLE 1 - seller
    CREATE TABLE seller(
        seller_id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(50) UNIQUE NOT NULL,
        phone_number VARCHAR(20) UNIQUE NOT NULL,
        created_at TIMESTAMP NOT NULL
    );

    -- TABLE 2 - buyer
    CREATE TABLE buyer(
        buyer_id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(50) UNIQUE NOT NULL,
        phone_number VARCHAR(20) UNIQUE NOT NULL,
        created_at TIMESTAMP NOT NULL
    );

    -- TABLE 3 - city
    CREATE TABLE city(
        city_id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        location POINT NOT NULL
    );

    -- TABLE 4 - seller_address
    CREATE TABLE seller_address(
        seller_address_id SERIAL PRIMARY KEY,
        seller_id INT NOT NULL
            REFERENCES seller(seller_id) ON DELETE CASCADE,
        city_id INT NOT NULL 
            REFERENCES city(city_id) ON DELETE RESTRICT,
        address VARCHAR(255) NOT NULL,
        zip_code INT NOT NULL
    );

    -- TABLE 5 - buyer_address
    CREATE TABLE buyer_address(
        buyer_address_id SERIAL PRIMARY KEY,
        buyer_id INT NOT NULL
            REFERENCES buyer(buyer_id) ON DELETE CASCADE,
        city_id INT NOT NULL 
            REFERENCES city(city_id) ON DELETE RESTRICT,
        address VARCHAR(255) NOT NULL,
        zip_code INT NOT NULL
    );

    -- TABLE 6 - products
    CREATE TABLE products(
        product_id SERIAL PRIMARY KEY,
        brand VARCHAR(50) NOT NULL,
        model VARCHAR(50) NOT NULL,
        type VARCHAR(50) NOT NULL,
        year INT NOT NULL,
        color VARCHAR(50),
        distance INT
    );

    -- TABLE 7 - ads
    CREATE TABLE ads(
        ad_id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        product_id INT NOT NULL 
            REFERENCES products(product_id) ON DELETE CASCADE,
        seller_id INT NOT NULL
            REFERENCES seller(seller_id) ON DELETE CASCADE,
        availability BOOL NOT NULL DEFAULT true,
        bids_allowed BOOL NOT NULL DEFAULT true,
        price INT NOT NULL CHECK(price > 0),
        created_at TIMESTAMP NOT NULL
    );

    -- TABLE 8 - bids
    CREATE TABLE bids(
        bid_id SERIAL PRIMARY KEY,
        ad_id INT NOT NULL
            REFERENCES seller(seller_id) ON DELETE CASCADE,
        buyer_id INT NOT NULL
            REFERENCES buyer(buyer_id) ON DELETE CASCADE,
        amount INT NOT NULL CHECK(amount > 0),
        status VARCHAR(20) CHECK(status IN ('Sent', 'Cancelled')),
        created_at TIMESTAMP NOT NULL
    );
```

# Populating the Database

Database ini menggunakan dummy dataset untuk mengisi data di dalam masing-masing tabel. Dummy dataset didapatkan dari sumber yang telah disediakan tim Pacmann dalam bentuk file Excel, maupun digenerate dengan menggunakan library `Faker` <br> Semua dummy data dikonversi ke dalam file CSV, lalu diimport ke dalam database menggunakan import tool pgAdmin 4.

**read_excel**

Modul `read_excel` berfungsi untuk mengambil data dari file Excel dengan bantuan library `openpyxl` lalu mengubahnya menjadi list dictionary yang dapat diolah lebih lanjut.
```
import openpyxl

def read_excel(file_name: str, worksheet_name: str):
    """
    Fungsi untuk membaca data dari file Excel/XLSX dan mengonversinya menjadi list of dictionary
    args:
        - file_name (str): nama file excel
        - worksheet_name (str): nama worksheet tempat data berada
    return:
        - data (list): list of dictionary dari data yang telah dikonversi
    """
    # Mengakses workbook dan worksheet dari file excel
    workbook = openpyxl.load_workbook(file_name)
    worksheet = workbook[worksheet_name]

    # Inisialisasi list data dan headers
    data = []
    headers = []

    # Looping sebanyak kolom worksheet untuk memasukkan nama kolom ke list headers
    for item in range(1, worksheet.max_column + 1):
        headers.append(worksheet.cell(row=1, column=item).value)

    # Looping sebanyak baris worksheet untuk memasukkan data sesuai kolomnya
    for row in worksheet.iter_rows(min_row=2, values_only=True):
        row_data = {}

        # Memasangkan key and value item sesuai kolom
        for item in range(len(headers)):
            key = headers[item]
            value = row[item]

            row_data[key] = value

        # Memasukkan dictionary ke list data
        data.append(row_data)

    return data
```

**show_data**

Modul `show_data` berfungsi untuk menampilkan tabel data yang telah digenerate. Tampilan dibuat dengan bantuan library `tabulate`
```
from tabulate import tabulate

def show_data(table: dict):
    """
    Fungsi untuk menampilkan data dalam bentuk tabulasi
    arg:
        - table (dict) : data yang ingin ditampilkan
    return:
        None
    """
    tab = tabulate(tabular_data=table,
                    headers=table.keys(),
                    tablefmt="psql",
                    numalign="center")
    print(tab)
```

**get_tables.py**

Modul `get_tables` membaca data file Excel menggunakan modul `read_excel` lalu mengembalikan dictionary yang dapat ditampilkan menggunakan modul `show_data` <br> File Excel yang tersedia yaitu:
- city
- car_product

Kedua dataset itu masing-masing akan diproses fungsi `get_city_table()` dan `get_product_table()` lalu mengembalikan dictionary `city` dan `product` <br> Khusus `product` juga ditambahkan kolom baru yang belum tersedia di file Excel lalu datanya digenerate dengan `Faker`
```
from read_excel import read_excel
from show_data import show_data
from faker import Faker

# membuat variabel untuk generator Faker dengan lokasi Indonesia
FAKER = Faker('id_ID')

def get_city_table(file_name: str, worksheet_name: str, is_print: bool):
    """
    Fungsi untuk mengambil dummy data tabel city dari file excel
    headers:
        - city_id
        - name
        - location
    args:
        - file_name (str): nama file excel
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """
    city_id = []
    name = []
    location = []

    # Menyimpan data hasil pembacaan file excel
    data = read_excel(file_name, worksheet_name)
    
    # Memasukkan data ke dalam masing-masing kolom tabel
    city = {}
    city["city_id"] = [int(data[i]["kota_id"]) for i in range(len(data))]
    city["name"] = [data[i]["nama_kota"] for i in range(len(data))]
    city["location"] = [f'{data[i]["longitude"]}, {data[i]["latitude"]}' for i in range(len(data))]

    # Menampilkan data jika diinginkan
    if is_print:
        show_data(city)
    
    return city

def get_product_table(file_name: str, worksheet_name: str, is_print: bool):
    """
    Fungsi untuk mengambil dummy data tabel product dari file excel
    headers:
        - product_id
        - brand
        - model
        - type
        - year
    arg:
        - file_name (str): nama file excel
        - worksheet_name (str): nama worksheet
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """
    # menyimpan data hasil pembacaan file excel
    data = read_excel(file_name, worksheet_name)
    
    # memasukkan data ke dalam masing-masing tabel
    product = {}
    product["product_id"] = [int(data[i]['product_id']) for i in range(len(data))]
    product["brand"] = [data[i]['brand'] for i in range(len(data))]
    product["model"] = [data[i]['model'] for i in range(len(data))]
    product["type"] = [data[i]['body_type'] for i in range(len(data))]
    product["year"] = [int(data[i]['year']) for i in range(len(data))]
    # menambahkan kolom color dan distance dengan data dummy
    product["color"] = [FAKER.color_name() for i in range(len(data))]
    product["distance"] = [FAKER.random_int(20_000, 100_000, 5_000) for i in range(len(data))]

    # menampilkan data jika diinginkan
    if is_print:
        show_data(product)
    
    return product
```

**create_tables.py**

Modul `create_tables` berisi fungsi-fungsi yang mengembalikan tabel berbentuk dictionary yang isinya digenerate menggunakan library `Faker` `datetime` (untuk data tanggal) dan `random` <br> Tabel yang dibuat di dalam `create_tables` yaitu:
- seller
- buyer
- seller_address
- buyer_address
- ads
- bids
```
from faker import Faker
from datetime import datetime
from show_data import show_data
import random

# membuat variabel untuk generator Faker dengan lokasi Indonesia
FAKER = Faker('id_ID')

def create_seller_table(n_seller: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel seller
    headers:
        - seller_id
        - name
        - email
        - phone number
        - created_at
    args:
        - n_seller (int): jumlah seller yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - seller (dict): data dalam bentuk tabel
    """
    # Membuat kolom-kolom tabel seller dengan masing-masing data dummy
    seller = {}
    seller["seller_id"] = [i+1 for i in range(n_seller)]
    seller["name"] = [f"{FAKER.first_name()} {FAKER.last_name()}" for i in range(n_seller)]
    seller["email"] = [f"{name.lower().replace(' ', '')}@{FAKER.free_email_domain()}" for name in seller["name"]]
    seller["phone_number"] = [FAKER.phone_number() for i in range(n_seller)]
    seller["created_at"] = [FAKER.date_time_between(
                            start_date=datetime(2022, 1, 1),
                            end_date=datetime(2023, 4, 16)
                            ) for i in range(n_seller)]

    # Menampilkan data jika diinginkan
    if is_print:
        show_data(seller)
    
    return seller

def create_buyer_table(n_buyer: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel buyer
    headers:
        - buyer_id
        - name
        - email
        - phone number
        - created_at
    args:
        - n_buyer (int): jumlah buyer yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - buyer (dict): data dalam bentuk tabel
    """
    # Membuat kolom-kolom tabel buyer dengan masing-masing data dummy
    buyer = {}
    buyer["buyer_id"] = [i+1 for i in range(n_buyer)]
    buyer["name"] = [f"{FAKER.first_name()} {FAKER.last_name()}" for i in range(n_buyer)]
    buyer["email"] = [f"{name.lower().replace(' ', '')}@{FAKER.free_email_domain()}" for name in buyer["name"]]
    buyer["phone_number"] = [FAKER.phone_number() for i in range(n_buyer)]
    buyer["created_at"] = [FAKER.date_time_between(
                            start_date=datetime(2022, 1, 1),
                            end_date=datetime(2023, 4, 16)
                            ) for i in range(n_buyer)]

    # Menampilkan data jika diinginkan
    if is_print:
        show_data(buyer)
    
    return buyer

def create_seller_address_table(seller: dict, city: dict, n_seller_address: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel seller_address
    headers:
        - seller_address_id
        - seller_id
        - city_id
        - address
        - zip_code
    args:
        - seller (dict): tabel seller
        - city (dict): tabel city
        - n_seller_address (int): jumlah seller address yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - seller_address (dict): data dalam bentuk tabel
    """
    # Membuat kolom-kolom tabel seller_address dengan masing-masing data dummy
    seller_address = {}
    seller_address["seller_address_id"] = [i+1 for i in range(n_seller_address)]
    seller_address["seller_id"] = [random.choice(seller["seller_id"]) for i in range(n_seller_address)]
    seller_address["city_id"] = [random.choice(city["city_id"]) for i in range(n_seller_address)]
    seller_address["address"] = [FAKER.address().split(",")[0] for i in range(n_seller_address)]
    seller_address["zip_code"] = [FAKER.postcode() for i in range(n_seller_address)]

    # Menampilkan data jika diinginkan
    if is_print:
        show_data(seller_address)
    
    return seller_address

def create_buyer_address_table(buyer: dict, city: dict, n_buyer_address: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel buyer_address
    headers:
        - buyer_address_id
        - buyer_id
        - city_id
        - address
        - zip_code
    args:
        - buyer (dict): tabel buyer
        - city (dict): tabel city
        - n_buyer_address (int): jumlah buyer address yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - buyer_address (dict): data dalam bentuk tabel
    """
    # Membuat kolom-kolom tabel buyer_address dengan masing-masing data dummy
    buyer_address = {}
    buyer_address["buyer_address_id"] = [i+1 for i in range(n_buyer_address)]
    buyer_address["buyer_id"] = [random.choice(buyer["buyer_id"]) for i in range(n_buyer_address)]
    buyer_address["city_id"] = [random.choice(city["city_id"]) for i in range(n_buyer_address)]
    buyer_address["address"] = [FAKER.address().split(",")[0] for i in range(n_buyer_address)]
    buyer_address["zip_code"] = [FAKER.postcode() for i in range(n_buyer_address)]

    # Menampilkan data jika diinginkan
    if is_print:
        show_data(buyer_address)
    
    return buyer_address

def create_ads_table(product: dict, seller: dict, n_ads: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel ads
    headers:
        - ad_id
        - title
        - product_id
        - seller_id
        - availability
        - bids_allowed
        - price
        - created_at
    args:
        - product (dict): tabel product
        - seller (dict): tabel seller
        - n_ads (int): jumlah ads yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - ads (dict): data dalam bentuk tabel
    """
    # Membuat kolom-kolom tabel ads dengan masing-masing data dummy
    ads = {}
    ads["ad_id"] = [i+1 for i in range(n_ads)]
    ads["title"] = [FAKER.text() for i in range(n_ads)]
    ads["product_id"] = [random.choice(product["product_id"]) for i in range(n_ads)]
    ads["seller_id"] = [random.choice(seller["seller_id"]) for i in range(n_ads)]
    ads["availability"] = [random.choice([True, False]) for i in range(n_ads)]
    ads["bids_allowed"] = [random.choice([True, False]) for i in range(n_ads)]
    ads["price"] = [FAKER.random_int(100_000_000, 800_000_000, 10_000_000) for i in range(n_ads)]
    ads["created_at"] = [FAKER.date_time_between(
                        start_date=datetime(2022, 1, 1),
                        end_date=datetime(2023, 4, 16)
                        ) for i in range(n_ads)]

    # Menampilkan data jika diinginkan
    if is_print:
        show_data(ads)
    
    return ads

def create_bids_table(ads: dict, buyer: dict, n_bids: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel bids
    headers:
        - bid_id
        - ad_id
        - buyer_id
        - amount
        - status
        - created_at
    args:
        - ads (dict): tabel ads
        - buyer (dict): tabel buyer
        - n_bids (int): jumlah bids yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - bids (dict): data dalam bentuk tabel
    """
    # Membuat kolom-kolom tabel bids dengan masing-masing data dummy
    bids = {}
    bids["bid_id"] = [i+1 for i in range(n_bids)]
    bids["ad_id"] = [random.choice(ads["ad_id"]) for i in range(n_bids)]
    bids["buyer_id"] = [random.choice(buyer["buyer_id"]) for i in range(n_bids)]
    bids["amount"] = [FAKER.random_int(100_000_000, 800_000_000, 10_000_000) for i in range(n_bids)]
    bids["status"] = ["".join(random.choices(["Sent", "Cancelled"], weights=(0.9, 0.1))) for i in range(n_bids)]
    bids["created_at"] = [FAKER.date_time_between(
                        start_date=datetime(2022, 1, 1),
                        end_date=datetime(2023, 4, 16)
                        ) for i in range(n_bids)]

    # Menampilkan data jika diinginkan
    if is_print:
        show_data(bids)
    
    return bids
```

**save_to_csv**

Modul `save_to_csv` menerima dictionary yang telah digenerate lalu menyimpannya ke dalam file CSV menggunakan bantuan library `csv`
```
import csv

def save_to_csv(data: dict, nama_file: str):
    """
    Fungsi untuk menyimpan data dummy ke file csv
    args:
        - data (dict): data yang akan dimasukkan ke dalam file csv
        - nama_file (str): nama untuk file csv
    return:
        None
    """
    # membuka file csv
    with open(file=f"{nama_file}.csv", mode="w", newline="") as csv_file:
        # membuat writer csv
        writer = csv.writer(csv_file)

        # write header csv
        writer.writerow(list(data.keys()))

        # mengetahui panjang data
        len_data = len(list(data.items())[0][1])

        # write data ke file csv
        for num in range(len_data):
            row = []
            for key in data.keys():
                row.append(data[key][num])
            writer.writerow(row)
```
Hasil akhirnya adalah 8 file CSV yang akan diimport ke dalam tabel-tabel di PostgreSQL database.

# Database Backup

Setelah semua tabel terisi, dilakukan backup agar proses restore database dapat dilakukan apabila ada kejadian tak terduga. Data backup disimpan di dalam file `backup.sql`

# Transactional Query

**1. Mencari mobil keluaran 2015 ke atas**

Query:
```
    SELECT 
        ad_id,
		product_id, 
		brand, 
		model, 
		year, 
        price 
	FROM 
        ads
	INNER JOIN 
        products
		USING(product_id)
	WHERE 
		year >= 2015
	ORDER BY 
		year ASC,
		ad_id ASC
```
Output:
![Output transactional query 1](https://i.imgur.com/mDq74CJ.png)

**2. Menambahkan satu data bid produk baru**

Query:
```
    INSERT INTO 
        bids(bid_id, ad_id, buyer_id, amount, status, created_at) 
        VALUES(21, 42, 7, 185500000, 'Sent', CURRENT_TIMESTAMP)
```
Output: <br> Sebelum insert data:
![Output transactional query 2 sebelum insert data](https://i.imgur.com/RiuTIuE.png)
![Output transactional query 2 sebelum insert data](https://i.imgur.com/VjSyibe.png)
Setelah insert data:
![Output transactional query 2 setelah insert data](https://i.imgur.com/ThsG7jq.png)

**3. Melihat semua mobil yg dijual 1 akun dari yg paling baru**

Misalnya dari akun dengan *seller_id = 11* <br> Query:
```
    SELECT 
		product_id, 
		brand, 
		model, 
		year, 
		price, 
		created_at 
	FROM 
		ads 
	INNER JOIN 
		products
		USING(product_id)
	WHERE 
		seller_id = 11
	ORDER BY 
		created_at DESC
```
Output:
![Output transactional query 3](https://i.imgur.com/MqVVkw7.png)

**4. Mencari mobil bekas yang termurah berdasarkan keyword**

Misalnya dengan keyword *"Yaris"* <br> Query:
```
    SELECT
		ad_id,
		product_id, 
		brand, 
		model, 
		year, 
		price
	FROM 
		ads 
	INNER JOIN 
		products
		USING(product_id)
	WHERE 
		model ILIKE '%Yaris%'
	ORDER BY 
		price ASC
```
Output:
![Output transactional query 4](https://i.imgur.com/HhCo4lG.png)

**5. Mencari mobil bekas yang terdekat berdasarkan sebuah id kota**

*Perhitungan jarak dapat dihitung menggunakan rumus jarak euclidean berdasarkan latitude dan longitude*

Misalnya mobil terdekat dengan *city_id = 3173* <br> Query:
```
    -- a. Membuat fungsi untuk menyimpan formula haversine
    CREATE FUNCTION haversine_distance(point_a POINT, point_b POINT)
    RETURNS float 
    LANGUAGE plpgsql
    
    AS 
    $$
    DECLARE
        lon_a float := radians(point_a[0]);
        lat_a float := radians(point_a[1]);
        lon_b float := radians(point_b[0]);
        lat_b float := radians(point_b[1]);
	
        d_lon float := lon_b - lon_a;
        d_lat float := lat_b - lat_a;
        a float;
        c float;
        r float := 6371;
        jarak float;
    BEGIN
        -- haversine formula
        a := sin(d_lat/2)^2 + cos(lat_a) * cos(lat_b) * sin(d_lon/2)^2;
        c := 2 * asin(sqrt(a));
        jarak := r * c;
        
        RETURN jarak;
    END
    $$
    -- b. Mencari jarak antar dua kota dengan menggunakan formula haversine
	SELECT
		product_id, 
        brand, 
        model, 
        year, 
        price,
        haversine_distance(location, (SELECT location FROM city WHERE city_id = 3173)) AS distance 
	FROM
		ads
	INNER JOIN
		products
		USING(product_id)
	LEFT JOIN
		seller_address
		USING(seller_id)
	LEFT JOIN
		city
		USING(city_id)
    ORDER BY 
        6 ASC, 
        1 ASC
```
Output:
![Output transactional query 5](https://i.imgur.com/ITFaA4h.png)

# Analytical Query

**1. Ranking popularitas model mobil berdasarkan jumlah bid**

Query:
```
    SELECT 
		model, 
		COUNT(product_id) AS count_product,
		COUNT(bid_id) AS count_bid
	FROM 
        ads
	INNER JOIN 
        products
		USING(product_id)
	LEFT JOIN
		bids
		USING(ad_id)
	GROUP BY 
		model
	ORDER BY
		count_bid DESC
```
Output:
![Output analytical query 1](https://i.imgur.com/rkUCJfa.png)

**2. Membandingkan harga mobil berdasarkan harga rata-rata per kota**

Query:
```
    SELECT 
		name AS nama_kota,
		brand,
		model,
		year,
		price,
		AVG(price) OVER(PARTITION BY name) AS avg_car_city
	FROM 
        city
	INNER JOIN
		seller_address
		USING(city_id)
	INNER JOIN
		ads
		USING(seller_id)
	LEFT JOIN
		products
		USING(product_id)
	ORDER BY
		6 ASC, 
        5 ASC
```
Output:
![Output analytical query 2](https://i.imgur.com/PXLWhIB.png)

**3. Dari penawaran suatu model mobil, cari perbandingan tanggal user melakukan bid dengan bid selanjutnya beserta harga tawar yang diberikan**

Misalnya bid untuk model *Toyota Yaris* <br> Query:
```
    SELECT 
        model,
        buyer_id,
        FIRST_VALUE(bids.created_at) OVER(PARTITION BY buyer_id) AS first_bid_date,
        LEAD(bids.created_at) OVER(PARTITION BY buyer_id) AS next_bid_date,
        FIRST_VALUE(amount) OVER(PARTITION BY buyer_id) AS first_bid_price,
        LEAD(amount) OVER(PARTITION BY buyer_id) AS next_bid_price
    FROM 
        bids
    INNER JOIN
        ads
        USING(ad_id)
    LEFT JOIN
        products
        USING(product_id)
    WHERE
        model = 'Toyota Yaris'
    ORDER BY
        3 ASC
```
Output:
![Output analytical query 3](https://i.imgur.com/XAtsa7U.png)

**4. Membandingkan persentase perbedaan rata-rata harga mobil berdasarkan modelnya dan rata-rata harga bid yang ditawarkan oleh customer pada 6 bulan terakhir**

Query:
```
    SELECT
        model,
        AVG(price) AS avg_price,
        AVG(amount) AS avg_bid_6month,
        AVG(price) - AVG(amount) AS difference,
        ((AVG(price) - AVG(amount)) / AVG(price))::float * 100 AS difference_percent
    FROM
        bids
    INNER JOIN
        ads
        USING(ad_id)
    LEFT JOIN
        products
        USING(product_id)
    WHERE
        bids.created_at >= CURRENT_TIMESTAMP - INTERVAL '6 months'
    GROUP BY
        model
```
Output:
![Output analytical query 4](https://i.imgur.com/GEHWk7m.png)

**5. Membuat window function rata-rata harga bid sebuah merk dan model mobil selama 6 bulan terakhir.**

Misalnya mobil *Toyota Yaris* <br> Query:
```
    WITH bids_yaris AS (	
	SELECT
		brand,
		model,
		bids.created_at,
		amount
    FROM
        bids
    INNER JOIN
        ads
        USING(ad_id)
    LEFT JOIN
        products
        USING(product_id)
	WHERE
		model = 'Toyota Yaris'
	)
	SELECT
		DISTINCT brand,
		model,
		(SELECT AVG(amount) FROM bids_yaris 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '6 months') AS m_min_6,
		(SELECT AVG(amount) FROM bids_yaris 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '5 months') AS m_min_5,
		(SELECT AVG(amount) FROM bids_yaris 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '4 months') AS m_min_4,
		(SELECT AVG(amount) FROM bids_yaris 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '3 months') AS m_min_3,
		(SELECT AVG(amount) FROM bids_yaris 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '2 months') AS m_min_2,
		(SELECT AVG(amount) FROM bids_yaris 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '1 months') AS m_min_1
	FROM
		bids_yaris
```
Output:
![Output analytical query 5](https://i.imgur.com/0HX8v7Y.png)