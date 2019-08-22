-- simple cube
SELECT
	d.day,
	m.rating,
	c.city,
	SUM(sales_amount) AS revenue
FROM
	dwh.fact_sale f
	JOIN dwh.dim_movie m ON (m.movie_key = f.movie_key)
	JOIN dwh.dim_date d ON (d.date_key = f.date_key)
	JOIN dwh.dim_customer c ON (c.customer_key = f.customer_key)
GROUP BY
	(d.day,
		m.rating,
		c.city)
ORDER BY
	revenue DESC
LIMIT 20;


-- slicing
SELECT
	d.day,
	m.rating,
	c.city,
	SUM(sales_amount) AS revenue
FROM
	dwh.fact_sale f
	JOIN dwh.dim_movie m ON (m.movie_key = f.movie_key)
	JOIN dwh.dim_date d ON (d.date_key = f.date_key)
	JOIN dwh.dim_customer c ON (c.customer_key = f.customer_key)
WHERE
	m.rating = 'PG-13'
GROUP BY
	(d.day,
		c.city,
		m.rating)
ORDER BY
	revenue DESC
LIMIT 20;

-- dicing
SELECT
	d.day,
	m.rating,
	c.city,
	SUM(sales_amount) AS revenue
FROM
	dwh.fact_sale f
	JOIN dwh.dim_movie m ON (m.movie_key = f.movie_key)
	JOIN dwh.dim_date d ON (d.date_key = f.date_key)
	JOIN dwh.dim_customer c ON (c.customer_key = f.customer_key)
WHERE
	m.rating in('PG-13', 'PG')
	AND c.city in('Bellevue', 'Lancaster')
	AND d.day in('1', '15', '30')
GROUP BY
	(d.day,
		c.city,
		m.rating)
ORDER BY
	revenue DESC
LIMIT 20;


-- rollup
SELECT
	d.day,
	m.rating,
	c.country,
	SUM(sales_amount) AS revenue
FROM
	dwh.fact_sale f
	JOIN dwh.dim_movie m ON (m.movie_key = f.movie_key)
	JOIN dwh.dim_date d ON (d.date_key = f.date_key)
	JOIN dwh.dim_customer c ON (c.customer_key = f.customer_key)
GROUP BY
	(d.day,
		m.rating,
		c.country)
ORDER BY
	revenue DESC
LIMIT 20;

-- drilldown
SELECT
	d.day,
	m.rating,
	c.district,
	SUM(sales_amount) AS revenue
FROM
	dwh.fact_sale f
	JOIN dwh.dim_movie m ON (m.movie_key = f.movie_key)
	JOIN dwh.dim_date d ON (d.date_key = f.date_key)
	JOIN dwh.dim_customer c ON (c.customer_key = f.customer_key)
GROUP BY
	(d.day,
		c.district,
		m.rating)
ORDER BY
	revenue DESC
LIMIT 20;

-- group set
SELECT
	d.month,
	s.country,
	SUM(sales_amount) AS revenue
FROM
	dwh.fact_sale f
	JOIN dwh.dim_date d ON (d.date_key = f.date_key)
	JOIN dwh.dim_store s ON (s.store_key = f.store_key)
GROUP BY
	GROUPING SETS ((),
		d.month,
		s.country,
		(d.month,
			s.country));

-- cube
SELECT
	d.month,
	s.country,
	SUM(sales_amount) AS revenue
FROM
	dwh.fact_sale f
	JOIN dwh.dim_date d ON (d.date_key = f.date_key)
	JOIN dwh.dim_store s ON (s.store_key = f.store_key)
GROUP BY
	CUBE (d.month,
		s.country);

