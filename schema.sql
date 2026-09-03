-- =========================================================
-- Zomato New Delhi Restaurant Analytics
-- PostgreSQL Schema
-- =========================================================
--
-- Source table used by the analysis queries:
--     restaurants
--
-- The column names below match the loaded Zomato dataset.
-- =========================================================

CREATE TABLE restaurants (
    "Restaurant ID" BIGINT,
    "Restaurant Name" TEXT,
    "Country Code" BIGINT,
    "City" TEXT,
    "Address" TEXT,
    "Locality" TEXT,
    "Locality Verbose" TEXT,
    "Longitude" DOUBLE PRECISION,
    "Latitude" DOUBLE PRECISION,
    "Cuisines" TEXT,
    "Average Cost for two" BIGINT,
    "Currency" TEXT,
    "Has Table booking" TEXT,
    "Has Online delivery" TEXT,
    "Is delivering now" TEXT,
    "Switch to order menu" TEXT,
    "Price range" BIGINT,
    "Aggregate rating" DOUBLE PRECISION,
    "Rating color" TEXT,
    "Rating text" TEXT,
    "Votes" BIGINT
);
