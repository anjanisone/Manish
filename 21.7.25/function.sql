DELIMITER $$

CREATE FUNCTION DoubleMetaphone(input_str VARCHAR(70))
RETURNS CHAR(10)
DETERMINISTIC
BEGIN
    DECLARE original VARCHAR(75);
    DECLARE primary_code VARCHAR(10) DEFAULT '';
    DECLARE secondary_code VARCHAR(10) DEFAULT '';
    DECLARE current INT DEFAULT 1;
    DECLARE length INT;
    DECLARE ch CHAR(1);
    DECLARE next_ch CHAR(1);
    DECLARE prev_ch CHAR(1);
    DECLARE SlavoGermanic INT DEFAULT 0;

    SET original = UPPER(IFNULL(input_str, ''));
    SET length = CHAR_LENGTH(original);

    IF LOCATE('W', original) > 0 OR LOCATE('K', original) > 0 OR LOCATE('CZ', original) > 0 OR LOCATE('WITZ', original) > 0 THEN
        SET SlavoGermanic = 1;
    END IF;

    IF LEFT(original, 2) IN ('GN', 'KN', 'PN', 'WR', 'PS') THEN
        SET current = current + 1;
    END IF;

    IF LEFT(original, 1) = 'X' THEN
        SET primary_code = CONCAT(primary_code, 'S');
        SET secondary_code = CONCAT(secondary_code, 'S');
        SET current = current + 1;
    END IF;

    IF LEFT(original, 1) IN ('A', 'E', 'I', 'O', 'U', 'Y') THEN
        SET primary_code = CONCAT(primary_code, 'A');
        SET secondary_code = CONCAT(secondary_code, 'A');
        SET current = current + 1;
    END IF;

    WHILE current <= length AND CHAR_LENGTH(primary_code) < 5 DO
        SET ch = SUBSTRING(original, current, 1);
        SET next_ch = SUBSTRING(original, current + 1, 1);
        SET prev_ch = IF(current > 1, SUBSTRING(original, current - 1, 1), '');

        IF ch IN ('A', 'E', 'I', 'O', 'U', 'Y') THEN
            SET current = current + 1;
        ELSEIF ch = 'B' THEN
            SET primary_code = CONCAT(primary_code, 'P');
            SET secondary_code = CONCAT(secondary_code, 'P');
            IF next_ch = 'B' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'Ç' THEN
            SET primary_code = CONCAT(primary_code, 'S');
            SET secondary_code = CONCAT(secondary_code, 'S');
            SET current = current + 1;
        ELSEIF ch = 'C' THEN
            IF next_ch = 'H' THEN
                SET primary_code = CONCAT(primary_code, 'X');
                SET secondary_code = CONCAT(secondary_code, 'X');
                SET current = current + 2;
            ELSEIF next_ch IN ('I','E','Y') THEN
                SET primary_code = CONCAT(primary_code, 'S');
                SET secondary_code = CONCAT(secondary_code, 'S');
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'K');
                SET secondary_code = CONCAT(secondary_code, 'K');
                SET current = current + 1;
            END IF;
        ELSEIF ch = 'D' THEN
            IF next_ch = 'G' AND SUBSTRING(original, current + 2, 1) IN ('E','I','Y') THEN
                SET primary_code = CONCAT(primary_code, 'J');
                SET secondary_code = CONCAT(secondary_code, 'J');
                SET current = current + 3;
            ELSE
                SET primary_code = CONCAT(primary_code, 'T');
                SET secondary_code = CONCAT(secondary_code, 'T');
                SET current = current + 1;
            END IF;
        ELSEIF ch = 'F' THEN
            SET primary_code = CONCAT(primary_code, 'F');
            SET secondary_code = CONCAT(secondary_code, 'F');
            IF next_ch = 'F' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'G' THEN
            SET primary_code = CONCAT(primary_code, 'K');
            SET secondary_code = CONCAT(secondary_code, 'K');
            IF next_ch = 'G' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'H' THEN
            IF next_ch IN ('A', 'E', 'I', 'O', 'U', 'Y') THEN
                SET primary_code = CONCAT(primary_code, 'H');
                SET secondary_code = CONCAT(secondary_code, 'H');
                SET current = current + 2;
            ELSE SET current = current + 1;
            END IF;
        ELSEIF ch = 'J' THEN
            SET primary_code = CONCAT(primary_code, 'J');
            SET secondary_code = CONCAT(secondary_code, 'J');
            IF next_ch = 'J' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'K' THEN
            SET primary_code = CONCAT(primary_code, 'K');
            SET secondary_code = CONCAT(secondary_code, 'K');
            IF next_ch = 'K' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'L' THEN
            SET primary_code = CONCAT(primary_code, 'L');
            SET secondary_code = CONCAT(secondary_code, 'L');
            IF next_ch = 'L' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'M' THEN
            SET primary_code = CONCAT(primary_code, 'M');
            SET secondary_code = CONCAT(secondary_code, 'M');
            IF next_ch = 'M' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'N' THEN
            SET primary_code = CONCAT(primary_code, 'N');
            SET secondary_code = CONCAT(secondary_code, 'N');
            IF next_ch = 'N' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'P' THEN
            IF next_ch = 'H' THEN
                SET primary_code = CONCAT(primary_code, 'F');
                SET secondary_code = CONCAT(secondary_code, 'F');
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'P');
                SET secondary_code = CONCAT(secondary_code, 'P');
                SET current = current + 1;
            END IF;
        ELSEIF ch = 'Q' THEN
            SET primary_code = CONCAT(primary_code, 'K');
            SET secondary_code = CONCAT(secondary_code, 'K');
            IF next_ch = 'Q' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'R' THEN
            SET primary_code = CONCAT(primary_code, 'R');
            SET secondary_code = CONCAT(secondary_code, 'R');
            IF next_ch = 'R' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'S' THEN
            IF next_ch = 'H' THEN
                SET primary_code = CONCAT(primary_code, 'X');
                SET secondary_code = CONCAT(secondary_code, 'X');
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'S');
                SET secondary_code = CONCAT(secondary_code, 'S');
                SET current = current + 1;
            END IF;
        ELSEIF ch = 'T' THEN
            IF next_ch = 'H' THEN
                SET primary_code = CONCAT(primary_code, '0');
                SET secondary_code = CONCAT(secondary_code, '0');
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'T');
                SET secondary_code = CONCAT(secondary_code, 'T');
                SET current = current + 1;
            END IF;
        ELSEIF ch = 'V' THEN
            SET primary_code = CONCAT(primary_code, 'F');
            SET secondary_code = CONCAT(secondary_code, 'F');
            IF next_ch = 'V' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSEIF ch = 'W' THEN
            SET primary_code = CONCAT(primary_code, 'W');
            SET secondary_code = CONCAT(secondary_code, 'W');
            SET current = current + 1;
        ELSEIF ch = 'X' THEN
            SET primary_code = CONCAT(primary_code, 'KS');
            SET secondary_code = CONCAT(secondary_code, 'KS');
            SET current = current + 1;
        ELSEIF ch = 'Z' THEN
            SET primary_code = CONCAT(primary_code, 'S');
            SET secondary_code = CONCAT(secondary_code, 'S');
            IF next_ch = 'Z' THEN SET current = current + 2; ELSE SET current = current + 1; END IF;
        ELSE
            SET current = current + 1;
        END IF;
    END WHILE;

    RETURN CONCAT(LPAD(primary_code, 5, ' '), LPAD(secondary_code, 5, ' '));
END $$

DELIMITER ;
