-- comment in jinja template is not working -> must be remove!
{{
    config
    (
        materialized = 'table',
        on_schema_change = 'sync_all_columns'
    )
}}
WITH u AS
(
    SELECT * FROM {{ ref("dim_user") }}
), ue AS
(
    SELECT * FROM {{ ref("fact_user_event") }}
)
SELECT
    variant_id,
    ue.user_id,
    datestamp,
    age,
    gender,
    COUNT(DISTINCT item_id) num_of_items, -- total impression
    COUNT(DISTINCT CASE WHEN clicked THEN item_id END) num_of_clicks, -- total click
    SUM(purchased) num_of_purchases, -- total purchase
    SUM(paidamount) revenue -- total revenue (수익)
FROM
    ue
    LEFT JOIN u
        ON ue.user_id = u.user_id
GROUP BY variant_id, ue.user_id, datestamp, age, gender
