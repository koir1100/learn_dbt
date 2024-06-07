SELECT
    *
FROM
(
    SELECT
        user_id, COUNT(user_id) AS cnt
    FROM
        {{ ref("dim_user_metadata") }}
    GROUP BY user_id
    ORDER BY cnt DESC
    LIMIT 1
)
WHERE cnt > 1
