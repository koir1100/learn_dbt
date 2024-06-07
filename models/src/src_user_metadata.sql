WITH src_user_metadata AS
(
    SELECT * FROM {{ source("yonggu_choi", "metadata") }}
)
SELECT
    user_id,
    age,
    gender,
    updated_at
FROM
    src_user_metadata
