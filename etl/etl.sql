INSERT INTO dwh.dim_date (date_key, date, year, quarter, month, day, week, is_weekend)
SELECT DISTINCT(TO_CHAR(payment_date :: DATE, 'yyyyMMDD')::integer) AS date_key,
       DATE(payment_date)                                           AS date,
       EXTRACT(YEAR FROM payment_date)                              AS year,
       EXTRACT(QUARTER FROM payment_date)                           AS quarter,
       EXTRACT(MONTH FROM payment_date)                             AS month,
       EXTRACT(DAY FROM payment_date)                               AS day,
       EXTRACT(WEEK FROM payment_date)                              AS week,
       CASE WHEN EXTRACT(ISODOW FROM payment_date) IN (6, 7) THEN TRUE ELSE FALSE END AS is_weekend
FROM payment;


INSERT INTO dwh.dim_customer (customer_key, customer_id, first_name, last_name, email, address, address2, district, city, country, postal_code, phone, active, create_date, start_date, end_date)
SELECT c.customer_id AS customer_key,
       c.customer_id,
       c.first_name,
       c.last_name,
       c.email,
       a.address,
       a.address2,
       a.district,
       ci.city,
       co.country,
       a.postal_code,
       a.phone,
       c.active,
       c.create_date,
       now()         AS start_date,
       now()         AS end_date
FROM customer c
JOIN address a  ON (c.address_id = a.address_id)
JOIN city ci    ON (a.city_id = ci.city_id)
JOIN country co ON (ci.country_id = co.country_id);

INSERT INTO dwh.dim_movie (movie_key, film_id, title, description, release_year, language, original_language, rental_duration, length, rating, special_features)
SELECT f.film_id      AS movie_key,
       f.film_id,
       f.title,
       f.description,
       f.release_year,
       l.name         AS language,
       orig_lang.name AS original_language,
       f.rental_duration,
       f.length,
       f.rating,
       f.special_features
FROM film f
JOIN language l              ON (f.language_id=l.language_id)
LEFT JOIN language orig_lang ON (f.original_language_id = orig_lang.language_id);

INSERT INTO dwh.dim_store (store_key, store_id, address, address2, district, city, country, postal_code, manager_first_name, manager_last_name, start_date, end_date)
SELECT s.store_id    AS store_key,
       s.store_id,
       a.address,
       a.address2,
       a.district,
       c.city,
       co.country,
       a.postal_code,
       st.first_name AS manager_first_name,
       st.last_name  AS manager_last_name,
       now()         AS start_date,
       now()         AS end_date
FROM store s
JOIN staff st   ON (s.manager_staff_id = st.staff_id)
JOIN address a  ON (s.address_id = a.address_id)
JOIN city c     ON (a.city_id = c.city_id)
JOIN country co ON (c.country_id = co.country_id);

INSERT INTO dwh.fact_sale (date_key, customer_key, movie_key, store_key, sales_amount)
SELECT TO_CHAR(p.payment_date :: DATE, 'yyyyMMDD')::integer AS date_key ,
       p.customer_id                                        AS customer_key,
       i.film_id                                            AS movie_key,
       i.store_id                                           AS store_key,
       p.amount                                             AS sales_amount
FROM payment p
JOIN rental r    ON ( p.rental_id = r.rental_id )
JOIN inventory i ON ( r.inventory_id = i.inventory_id );