WITH src_user_variant AS
(
    SELECT * FROM {{ source("yonggu_choi", "variant") }}
)
SELECT
    user_id,
    variant_id
FROM
    src_user_variant
