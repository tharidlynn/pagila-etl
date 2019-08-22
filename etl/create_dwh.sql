CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS dwh;


CREATE TABLE IF NOT EXISTS dwh.dim_date (
    date_key INT NOT NULL PRIMARY KEY,
    date DATE NOT NULL,
    year SMALLINT NOT NULL,
    quarter SMALLINT NOT NULL,
    month SMALLINT NOT NULL,
    day SMALLINT NOT NULL,
    week SMALLINT NOT NULL,
    is_weekend BOOLEAN
);


CREATE TABLE IF NOT EXISTS dwh.dim_customer (
  customer_key SERIAL PRIMARY KEY,
  customer_id  SMALLINT NOT NULL,
  first_name   VARCHAR(45) NOT NULL,
  last_name    VARCHAR(45) NOT NULL,
  email        VARCHAR(50),
  address      VARCHAR(50) NOT NULL,
  address2     VARCHAR(50),
  district     VARCHAR(20) NOT NULL,
  city         VARCHAR(50) NOT NULL,
  country      VARCHAR(50) NOT NULL,
  postal_code  VARCHAR(10),
  phone        VARCHAR(20) NOT NULL,
  active       SMALLINT NOT NULL,
  create_date  TIMESTAMP NOT NULL,
  start_date   DATE NOT NULL,
  end_date     DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS dwh.dim_movie (
  movie_key          SERIAL PRIMARY KEY,
  film_id            SMALLINT NOT NULL,
  title              VARCHAR(255) NOT NULL,
  description        TEXT,
  release_year       YEAR,
  language           VARCHAR(20) NOT NULL,
  original_language  VARCHAR(20),
  rental_duration    SMALLINT NOT NULL,
  length             SMALLINT NOT NULL,
  rating             VARCHAR(5) NOT NULL,
  special_features   VARCHAR(60) NOT NULL
);

CREATE TABLE dwh.dim_store (
  store_key           SERIAL PRIMARY KEY,
  store_id            SMALLINT NOT NULL,
  address             VARCHAR(50) NOT NULL,
  address2            VARCHAR(50),
  district            VARCHAR(20) NOT NULL,
  city                VARCHAR(50) NOT NULL,
  country             VARCHAR(50) NOT NULL,
  postal_code         VARCHAR(10),
  manager_first_name  VARCHAR(45) NOT NULL,
  manager_last_name   VARCHAR(45) NOT NULL,
  start_date          DATE NOT NULL,
  end_date            DATE NOT NULL
);

CREATE TABLE dwh.fact_sale (
    sale_key SERIAL PRIMARY KEY,
    date_key INT NOT NULL REFERENCES dwh.dim_date(date_key),
    customer_key INT NOT NULL REFERENCES dwh.dim_customer(customer_key),
    movie_key INT NOT NULL REFERENCES dwh.dim_movie(movie_key),
    store_key INT NOT NULL REFERENCES dwh.dim_store(store_key),
    sales_amount DECIMAL(5,2) NOT NULL 
);