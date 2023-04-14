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
        status VARCHAR(20) CHECK(status IN ('Sent', 'Cancelled')),
        created_at TIMESTAMP NOT NULL
    );