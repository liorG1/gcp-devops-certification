-- All queries are configured for project: terraform-learning-503012

-- 1. Latency Analysis
SELECT hour, MIN(took_ms) AS min, MAX(took_ms) AS max, AVG(took_ms) AS avg
FROM (
  SELECT FORMAT_TIMESTAMP("%H", timestamp) AS hour, CAST(JSON_VALUE(json_payload, '$."http.resp.took_ms"') AS INT64) AS took_ms
  FROM `terraform-learning-503012.global.day2ops-log._AllLogs`
  WHERE timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
    AND json_payload IS NOT NULL AND SEARCH(labels, "frontend") AND JSON_VALUE(json_payload.message) = "request complete"
) GROUP BY 1 ORDER BY 1;

-- 2. Product Visits
SELECT count(*) FROM `terraform-learning-503012.global.day2ops-log._AllLogs`
WHERE text_payload LIKE "GET %/product/L9ECAV7KIM %" AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR);

-- 3. Checkout Sessions
SELECT JSON_VALUE(json_payload.session), COUNT(*) FROM `terraform-learning-503012.global.day2ops-log._AllLogs`
WHERE JSON_VALUE(json_payload['http.req.method']) = "POST" AND JSON_VALUE(json_payload['http.req.path']) = "/cart/checkout"
  AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR) GROUP BY JSON_VALUE(json_payload.session);
