
# Data Analytics for an E-commerce Platform

#### -- Project Status: [Completed]

## Project Objective
This project, completed as a part of the Advanced MySQL Data Analysis course, explores the data-driven operations of an e-commerce platform. It encompasses a thorough analysis of a SQL-based relational dataset, including customer order information, marketing campaign and website traffic data. Utilizing complex MySQL queries, I've dissected commercial activities to identify key trends, assess business growth, and enhance digital marketing strategies—essential for strategic decision-making. The primary objectives of the analysis are to:

- Measure user behaviours and evaluate the effectiveness of marketing campaigns to optimise sales and user experience

- Assess the performance of products such as identifying best-selling items, success of new product launches, and cross-sell opportunities

- Examine how users interact with products/services, including their purchasing patterns, engagement levels

### Skills Used
* Web/Channel Analytics
* Product Analytics
* User Behaviour Analytics

### Technologies
* MySQL

## Getting Started
 
1. Data analysis scripts are documented in three separate notebooks:
   - [Web Analytics](https://github.com/khinydnlin/portfolio/blob/main/E-commerce%20Analytics/1.%20Channel%20Analytics%20-%20E-Commerce.ipynb)
   - [Product Analytics](https://github.com/khinydnlin/portfolio/blob/main/E-commerce%20Analytics/2.%20Product%20Analytics%20-%20E-commerce.ipynb)
   - [User Behaviour Analytics](https://github.com/khinydnlin/portfolio/blob/main/E-commerce%20Analytics/3.%20User%20Behaviour%20Analytics%20-%20E-commerce.ipynb)
     
2. Data Description

| Tables                  | Columns              |
|-------------------------|----------------------|
| order_item_refunds      | created_at           |
| order_item_refunds      | order_id             |
| order_item_refunds      | order_item_id        |
| order_item_refunds      | order_item_refund_id |
| order_item_refunds      | refund_amount_usd    |
| order_items             | cogs_usd             |
| order_items             | created_at           |
| order_items             | is_primary_item      |
| order_items             | order_id             |
| order_items             | order_item_id        |
| order_items             | price_usd            |
| order_items             | product_id           |
| orders                  | cogs_usd             |
| orders                  | created_at           |
| orders                  | items_purchased      |
| orders                  | order_id             |
| orders                  | price_usd            |
| orders                  | primary_product_id   |
| orders                  | user_id              |
| orders                  | website_session_id   |
| products                | created_at           |
| products                | product_id           |
| products                | product_name         |
| website_pageviews       | created_at           |
| website_pageviews       | pageview_url         |
| website_pageviews       | website_pageview_id  |
| website_pageviews       | website_session_id   |
| website_sessions        | created_at           |
| website_sessions        | device_type          |
| website_sessions        | http_referer         |
| website_sessions        | is_repeat_session    |
| website_sessions        | user_id              |
| website_sessions        | utm_campaign         |
| website_sessions        | utm_content          |
| website_sessions        | utm_source           |
| website_sessions        | website_session_id   |
