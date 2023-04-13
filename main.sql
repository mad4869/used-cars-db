-- BACKGROUND

-- Membangun RELATIONAL DATABASE untuk sebuah WEBSITE PENJUALAN MOBIL BEKAS
    -- Siapa saja dapat menawarkan produk atau melakukan pencarian produk


-- FEATURE & CONSTRAINT

-- 1. Setiap user dapat menawarkan 1 ATAU LEBIH produk
-- 2. Setiap user harus melengkapi data diri
    -- NAMA
    -- KONTAK
    -- DOMISILI
-- 3. User menawarkan produk melalui IKLAN WEBSITE
    -- JUDUL IKLAN
    -- DETAIL INFORMASI PRODUK
        -- i. MEREK MOBIL
        -- ii. MODEL
        -- iii. JENIS BODY
        -- iv. TIPE
        -- v. TAHUN PEMBUATAN
        -- vi. ETC.
    -- KONTAK PENJUAL
-- 4. Setiap user dapat mencari produk berdasar:
    -- LOKASI PENJUAL
    -- MEREK MOBIL
    -- JENIS BODY
-- 5. Calon pembeli dapat melakukan BID/PENAWARAN HARGA


-- STEPS BY STEPS

-- 1. Mission Statement
    -- Case Description
    -- Mission Statement
-- 2. Create Table Structures
    -- Determine the Columns and Data Type
-- 3. Determine Table Relationship
    -- Determine Primary and Foreign Key
-- 4. Determine Bussiness Rule
    -- Field-specific Rule
    -- Relationship-specific Rule
-- 5. Determine Views
    -- SELECT Statements


-- CREATING TABLES

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
        status VARCHAR(20) CHECK(status IN ('Sent', 'Not Sent')),
        created_at TIMESTAMP NOT NULL
    );


-- QUERY

-- TRANSACTIONAL QUERY
	
    -- No.1
	-- Mencari mobil keluaran 2015 ke atas	
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
    
    -- No. 2
    -- Menambahkan satu data bid produk baru
    -- a. Insert data ke dalam tabel bids
    INSERT INTO 
        bids(bid_id, ad_id, buyer_id, amount, status, created_at) 
        VALUES(21, 42, 7, 185500000, 'Sent', CURRENT_TIMESTAMP)
    -- b. Melihat data tabel bids untuk memastikan data yang baru diinput telah masuk
    SELECT 
        bid_id,
        ad_id,
        product_id,
        buyer_id,
        bids.created_at,
        amount,
        status
    FROM 
        bids
    INNER JOIN
        ads
        USING(ad_id)
    
    -- No.3
	-- Melihat semua mobil yang dijual 1 akun dari yang paling baru
	-- Akun "Nadine Setiawan", seller_id = 11	
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

    -- No.4
	-- Mencari mobil bekas yang termurah berdasarkan keyword
	-- Keyword = "Yaris"	
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
    
    -- No. 5
    -- Mencari mobil bekas terdekat berdasarkan id kota 
    -- (dihitung menggunakan rumus euclidean berdasarkan latitude dan longitude)
    -- id kota = 3173, nama kota = Kota Jakarta Barat
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

-- ANALYTICAL QUERY
	
    -- No.1
	-- Ranking popularitas model mobil berdasarkan jumlah bid	
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
    
    -- No.2
	-- Membandingkan harga mobil berdasarkan harga rata-rata per kota	
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
    
    -- No. 3
    -- Perbandingan tanggal user melakukan bid dengan bid selanjutnya beserta harga tawar
    -- Bid untuk model mobil "Daihatsu Terios"
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
        model = 'Daihatsu Terios'
    ORDER BY
        3 ASC
    
    -- No. 4
    -- Membandingkan persentase perbedaan rata-rata harga mobil berdasarkan model
    -- dan rata-rata harga bid yang ditawarkan customer pada 6 bulan terakhir
    -- Difference = (rata-rata harga mobil) - (rata-rata harga bid 6 bulan terakhir)
    -- Difference percent = ((Difference) / (rata-rata harga mobil) * 100)
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
    
    -- No. 5
    -- Window function rata-rata harga bid merk dan model mobil selama 6 bulan terakhir
    -- Model mobil = "Daihatsu Terios"
    WITH bids_terios AS (	
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
		model = 'Daihatsu Terios'
	)
	SELECT
		DISTINCT brand,
		model,
		COALESCE((SELECT AVG(amount) FROM bids_terios 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '6 months'), 0) AS m_min_6,
		COALESCE((SELECT AVG(amount) FROM bids_terios 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '5 months'), 0) AS m_min_5,
		COALESCE((SELECT AVG(amount) FROM bids_terios 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '4 months'), 0) AS m_min_4,
		COALESCE((SELECT AVG(amount) FROM bids_terios 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '3 months'), 0) AS m_min_3,
		COALESCE((SELECT AVG(amount) FROM bids_terios 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '2 months'), 0) AS m_min_2,
		COALESCE((SELECT AVG(amount) FROM bids_terios 
                WHERE created_at >= CURRENT_TIMESTAMP - interval '1 months'), 0) AS m_min_1
	FROM
		bids_terios