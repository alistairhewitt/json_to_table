DELIMITER //

CREATE PROCEDURE json_to_table(IN json_obj JSON)
BEGIN
    DECLARE num_pairs INT;
    DECLARE json_keys JSON;

    -- Check if the input is a valid JSON object
    IF NOT JSON_VALID(json_obj) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON object', MYSQL_ERRNO = 333;
    END IF;

    -- Parse the input JSON string
    SET num_pairs = JSON_LENGTH(json_obj);
    SET json_keys = JSON_KEYS(json_obj);

    -- Extract the key-value pairs from the JSON object using a Common Table Expression
    WITH RECURSIVE cte AS (
        SELECT 0 as n,
                JSON_UNQUOTE(JSON_EXTRACT(json_keys, CONCAT('$[', 0, ']'))) AS `key`,
                JSON_UNQUOTE(JSON_EXTRACT(json_obj, CONCAT('$."', JSON_UNQUOTE(JSON_EXTRACT(json_keys, CONCAT('$[', 0, ']'))), '"'))) AS `value`
        UNION ALL
        SELECT n+1,
                JSON_UNQUOTE(JSON_EXTRACT(json_keys, CONCAT('$[', n+1, ']'))) AS `key`,
                JSON_UNQUOTE(JSON_EXTRACT(json_obj, CONCAT('$."', JSON_UNQUOTE(JSON_EXTRACT(json_keys, CONCAT('$[', n+1, ']'))), '"'))) AS `value`
        FROM cte WHERE n+1 < num_pairs
    )
    SELECT `key`, `value` FROM cte;
END;

//

DELIMITER ;
