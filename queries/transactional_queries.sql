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
	-- Akun "Dodo Mahendra", seller_id = 11	
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