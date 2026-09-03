# Zomato New Delhi Restaurant Analytics

SQL and PostgreSQL analysis of Zomato restaurant data to uncover insights into ratings, pricing, locality performance, cuisine diversity, customer engagement, and service features.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Business Questions](#business-questions)
- [Dataset](#dataset)
- [Tools & Technologies](#tools--technologies)
- [Project Workflow](#project-workflow)
- [Key Analyses & Findings](#key-analyses--findings)
  - [1. Highly Rated Restaurants with Online Delivery](#1-highly-rated-restaurants-with-online-delivery)
  - [2. Value Score](#2-value-score)
  - [3. Locality Hotspots](#3-locality-hotspots)
  - [4. Cuisine Diversity](#4-cuisine-diversity)
  - [5. Cost Segmentation](#5-cost-segmentation)
  - [6. Online Delivery & Table Booking](#6-online-delivery--table-booking)
  - [7. Expensive Cuisine Categories](#7-expensive-cuisine-categories)
  - [8. Locality Engagement](#8-locality-engagement)
  - [9. Restaurant vs. Locality Benchmark](#9-restaurant-vs-locality-benchmark)
  - [10. Popular Restaurants](#10-popular-restaurants)
  - [11. Weighted Restaurant Rating](#11-weighted-restaurant-rating)
  - [12. Dwarka Data Availability](#12-dwarka-data-availability)
- [SQL Concepts Demonstrated](#sql-concepts-demonstrated)
- [Project Structure](#project-structure)
- [Replication](#replication)
- [Key Takeaways](#key-takeaways)
- [Author](#author)

---

## Project Overview

This project analyzes restaurant data from Zomato using **SQL and PostgreSQL** to uncover insights into restaurant ratings, pricing, locality performance, cuisine diversity, customer engagement, and service features.

The project was motivated by my internship experience at **NHAI Headquarters in New Delhi**, where working with location-based and operational data provided context for exploring how geographic and business characteristics can be analyzed using structured datasets.

The primary analysis focuses on **New Delhi**, while selected analyses are intentionally performed across the complete dataset to identify broader patterns in pricing, cuisine diversity, and service features.

---

## Business Questions

### Restaurant Discovery

* Which highly-rated restaurants offer online delivery?
* Which restaurants provide the best value relative to their cost?
* Which restaurants are the most popular based on customer votes?

### Locality Analysis

* Which New Delhi localities have the highest concentration of highly-rated restaurants?
* Which localities demonstrate the strongest customer engagement?
* Which restaurants significantly outperform their locality average?

### Pricing & Cuisine

* How does restaurant pricing vary across cost segments?
* Which cuisine combinations have the highest average cost?
* Is higher pricing associated with greater customer engagement?

### Service Features

* How are online delivery and table booking associated with restaurant ratings and customer engagement?

### Advanced Ranking

* How can restaurant ratings be adjusted to account for differences in the number of votes?
* Which restaurants remain highly ranked after applying a weighted rating approach?

### Geographic Data Exploration

* How much restaurant data is available specifically for Dwarka?
* Is the available Dwarka sample large enough to support meaningful locality-level analysis?

---

## Dataset

The project uses the **Zomato Restaurants Data** dataset available on Kaggle.

**Dataset:** [Zomato Restaurants Data](https://www.kaggle.com/datasets/mathurutkarsh/zomato-dataset)

The dataset contains **9,551 restaurant records and 21 attributes**.

Key fields include:

| Field                    | Description                             |
| ------------------------ | --------------------------------------- |
| `Restaurant ID`          | Unique restaurant identifier            |
| `Restaurant Name`        | Name of the restaurant                  |
| `City`                   | City in which the restaurant is located |
| `Locality`               | Restaurant locality                     |
| `Locality Verbose`       | Detailed locality description           |
| `Cuisines`               | Cuisine or cuisine combination          |
| `Average Cost for two`   | Average cost for two people             |
| `Price range`            | Price category                          |
| `Aggregate rating`       | Restaurant rating out of 5              |
| `Votes`                  | Number of customer votes                |
| `Has Table booking`      | Table booking availability              |
| `Has Online delivery`    | Online delivery availability            |
| `Is delivering now`      | Current delivery availability           |
| `Latitude` / `Longitude` | Geographic coordinates                  |

---

## Tools & Technologies

* **SQL**
* **PostgreSQL 14**
* **Python**
* **Pandas**
* **Psycopg2**
* **SQLAlchemy**
* **Jupyter Notebook**
* **Kaggle Dataset**

---

## Project Workflow

1. Loaded the Zomato CSV dataset using Pandas.
2. Handled character encoding using `latin1`.
3. Loaded the dataset into PostgreSQL.
4. Validated the database schema and records.
5. Filtered New Delhi restaurants for location-specific analysis.
6. Used SQL aggregation, ranking, window functions, CTEs, and benchmarking.
7. Created derived analytical metrics and scores.
8. Interpreted the results from a business and product analytics perspective.

---

# Key Analyses & Findings

## 1. Highly Rated Restaurants with Online Delivery

New Delhi restaurants offering online delivery were ranked using:

* Aggregate rating
* Number of votes

Examples of highly-rated restaurants with online delivery include:

* Naturals Ice Cream, Connaught Place: **4.9 rating, 2,620 votes**
* Naturals Ice Cream, Rajouri Garden: **4.7 rating, 474 votes**
* Spezia Bistro, Delhi University-GTB Nagar: **4.6 rating, 1,071 votes**
* Coast Cafe, Hauz Khas Village: **4.5 rating, 1,033 votes**

This combines customer satisfaction with engagement rather than relying on rating alone.

---

## 2. Value Score

A custom **Value Score** was created to identify restaurants offering strong ratings relative to their cost.

### Formula

$$
\text{Value Score} =
\frac{\text{Aggregate Rating}}
{\text{Average Cost for two}}
\times 100
$$

The highest scores were concentrated among low-cost restaurants such as:

| Restaurant                | Locality            | Rating | Cost for Two | Value Score |
| ------------------------- | ------------------- | -----: | -----------: | ----------: |
| Jung Bahadur Kachori Wala | Chandni Chowk       |    4.1 |          ₹50 |    **8.20** |
| Sharma Kachoriwala        | Kamla Nagar         |    3.7 |          ₹50 |    **7.40** |
| Pakode Ki Dukaan          | Karol Bagh          |    3.6 |          ₹50 |    **7.20** |
| Duggal Snacks             | Mayur Vihar Phase 2 |    3.6 |          ₹50 |    **7.20** |

The metric highlights restaurants that may be overlooked when ranking purely by rating.

---

## 3. Locality Hotspots

Localities were evaluated based on the number of restaurants with ratings of at least 4.0.

| Locality          | Restaurants ≥ 4.0 | Avg. Rating |
| ----------------- | ----------------: | ----------: |
| Connaught Place   |                32 |        4.18 |
| Rajouri Garden    |                24 |        4.26 |
| Greater Kailash 1 |                17 |        4.16 |
| Satyaniketan      |                15 |        4.15 |
| Khan Market       |                14 |        4.19 |

This shows that strong restaurant performance is concentrated in specific dining and commercial clusters.

---

## 4. Cuisine Diversity

Cuisine diversity was measured using the number of distinct cuisine combinations associated with each locality.

This analysis was performed across the **complete dataset**.

| Locality        | Distinct Cuisine Combinations |
| --------------- | ----------------------------: |
| Connaught Place |                            90 |
| Rajouri Garden  |                            71 |
| Satyaniketan    |                            61 |
| Malviya Nagar   |                            60 |
| Defence Colony  |                            55 |

This provides a measure of how varied the restaurant offering is across different locations.

---

## 5. Cost Segmentation

Restaurants were segmented based on average cost for two.

| Segment   | Cost for Two | Restaurants | Avg. Rating | Avg. Votes |
| --------- | -----------: | ----------: | ----------: | ---------: |
| Budget    |       ≤ ₹300 |       2,208 |        3.51 |        156 |
| Mid-Range |    ₹301–₹700 |       3,197 |        3.26 |        109 |
| Premium   |  ₹701–₹1,500 |       1,407 |        3.58 |        353 |
| Luxury    |     > ₹1,500 |         573 |        3.77 |        538 |

Luxury restaurants received approximately **4.9× more votes than mid-range restaurants on average**.

This indicates an association between price positioning and customer engagement, but does not establish causality.

---

## 6. Online Delivery & Table Booking

The relationship between service features and restaurant performance was analyzed across the **complete dataset**.

| Online Delivery | Table Booking | Avg. Rating | Avg. Votes |
| --------------- | ------------- | ----------: | ---------: |
| Yes             | Yes           |        3.61 |        476 |
| No              | Yes           |        3.57 |        299 |
| No              | No            |        3.45 |        178 |
| Yes             | No            |        3.33 |        162 |

Restaurants offering both services compared with restaurants offering neither showed:

* **+0.16 rating points**
* Approximately **4.6% higher average rating**
* Approximately **2.67× higher average votes**

These results indicate an **association**, not a causal impact of service availability.

---

## 7. Expensive Cuisine Categories

Cuisine combinations were ranked by average cost for two, considering groups with at least five restaurants.

| Cuisine Combination                | Restaurants | Avg. Cost | Avg. Rating |
| ---------------------------------- | ----------: | --------: | ----------: |
| Modern Indian                      |           5 |    ₹2,980 |        4.58 |
| Continental                        |           9 |    ₹2,444 |        3.58 |
| Continental, North Indian, Italian |           5 |    ₹2,320 |        3.56 |
| Finger Food                        |          30 |    ₹2,293 |        2.68 |
| Italian                            |          12 |    ₹1,975 |        3.16 |

Modern Indian restaurants had an average cost approximately **51% higher than Italian restaurants** within the analyzed groups.

---

## 8. Locality Engagement

Localities were compared using both total votes and average votes per restaurant.

| Locality            | Restaurants | Total Votes | Avg. Votes |
| ------------------- | ----------: | ----------: | ---------: |
| Hauz Khas Village   |          24 |      32,573 |      1,357 |
| Connaught Place     |         119 |     128,107 |      1,077 |
| Pandara Road Market |          10 |       7,978 |        798 |
| Khan Market         |          43 |      28,463 |        662 |

Hauz Khas Village had approximately **26% higher average votes per restaurant than Connaught Place**, despite having significantly fewer restaurants.

This demonstrates why restaurant count alone is not sufficient to measure locality strength.

---

## 9. Restaurant vs. Locality Benchmark

Each restaurant was benchmarked against the average rating of its locality.

### Locality Performance Score

$$
\text{Locality Performance Score} =
\frac{\text{Restaurant Rating}}
{\text{Locality Average Rating}}
\times 100
$$

For example:

* **Masala Library**
* Restaurant rating: **4.9**
* Locality average: approximately **3.57**
* Performance Score: **137.3**

This means the restaurant's rating was approximately **37.3% above its locality average**.

The benchmark provides additional context beyond comparing restaurants solely on absolute ratings.

---

## 10. Popular Restaurants

Restaurants were ranked by the number of customer votes as a proxy for customer engagement.

| Rank | Restaurant       | Locality          | Rating | Votes |
| ---: | ---------------- | ----------------- | -----: | ----: |
|    1 | Hauz Khas Social | Hauz Khas Village |    4.3 | 7,931 |
|    2 | Saravana Bhavan  | Connaught Place   |    4.3 | 5,172 |
|    3 | Big Chill        | Khan Market       |    4.5 | 4,986 |
|    4 | Warehouse Cafe   | Connaught Place   |    3.7 | 4,914 |
|    5 | Karim's          | Jama Masjid       |    4.0 | 4,689 |

Hauz Khas Social received approximately **53% more votes than Saravana Bhavan**.

---

## 11. Weighted Restaurant Rating

Raw ratings can be misleading when a restaurant has very few votes.

To account for this, a **Bayesian-style weighted rating** was calculated.

### Formula

$$
WR =
\frac{v}{v+m}R
+
\frac{m}{v+m}C
$$

Where:

* $R$ = restaurant's average rating
* $v$ = number of votes for the restaurant
* $C$ = overall New Delhi average rating
* $m$ = 75th percentile of votes

Restaurants with more votes receive greater weight on their observed rating, while restaurants with fewer votes are pulled toward the overall average.

This produces a more robust ranking than sorting by aggregate rating alone.

---

## 12. Dwarka Data Availability

Since the project was motivated by an internship at NHAI Headquarters in New Delhi, the dataset was specifically checked for Dwarka-related records.

Only **one New Delhi restaurant record** was associated with Dwarka in the available dataset.

Therefore, Dwarka was not treated as a statistically meaningful locality segment in the main analysis.

This highlights an important data-quality consideration: geographic segments should not be over-interpreted when the available sample is too small.

---

# SQL Concepts Demonstrated

The project demonstrates:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* Aggregate functions
* `CASE WHEN`
* CTEs
* Subqueries
* `JOIN`
* Window functions
* `RANK()`
* `PARTITION BY`
* Conditional aggregation
* Percentile calculations
* Derived metrics
* Benchmarking
* Weighted scoring

---

# Project Structure

```text
Zomato-New-Delhi-Analytics/
│
├── README.md
├── analysis_queries.sql
├── schema.sql
│
└── notebooks/
    └── zomato_delhi_analysis.ipynb
```

---

# Replication

### 1. Clone the repository

```bash
git clone https://github.com/GITtal-Di/Zomato-New-Delhi-Analytics.git
cd Zomato-New-Delhi-Analytics
```

### 2. Create PostgreSQL database

```sql
CREATE DATABASE mydb;
```

### 3. Install dependencies

```bash
pip install pandas psycopg2-binary sqlalchemy
```

### 4. Load the dataset

Download the [Zomato dataset](https://www.kaggle.com/datasets/mathurutkarsh/zomato-dataset), then load `zomato.csv` using:

```python
df = pd.read_csv("zomato.csv", encoding="latin1")
```

### 5. Load into PostgreSQL

Update the PostgreSQL connection credentials if required, then load the dataframe into the `restaurants` table.

### 6. Run the SQL

Execute `schema.sql` and `analysis_queries.sql` against the PostgreSQL database.

---

# Key Takeaways

The analysis demonstrates that restaurant performance cannot be evaluated using rating alone.

Different metrics reveal different aspects of the market:

* **Ratings** measure perceived customer satisfaction.
* **Votes** provide a proxy for customer engagement.
* **Value Score** combines affordability with rating.
* **Locality Performance Score** provides geographic context.
* **Cuisine diversity** measures variety in restaurant offerings.
* **Service feature analysis** identifies associations with ratings and engagement.
* **Weighted ratings** reduce the influence of restaurants with very few votes.

Together, these metrics provide a multi-dimensional framework for understanding restaurant performance, customer engagement, pricing, and locality-level patterns.

---

# Author

**Yash Goyal**

[GitHub Profile](https://github.com/GITtal-Di)

**Data Analytics | SQL | PostgreSQL | Python**
