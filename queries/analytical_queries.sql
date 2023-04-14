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
    -- Bid untuk model mobil "Toyota Yaris"
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
    -- Model mobil = "Toyota Yaris"
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