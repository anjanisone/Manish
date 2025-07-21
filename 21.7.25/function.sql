DELIMITER $$

CREATE FUNCTION DoubleMetaphone(str VARCHAR(70)) RETURNS VARCHAR(10)
BEGIN
    DECLARE original VARCHAR(70);
    DECLARE primary_code VARCHAR(10) DEFAULT '';
    DECLARE secondary_code VARCHAR(10) DEFAULT '';
    DECLARE length_val INT;
    DECLARE last INT;
    DECLARE current INT DEFAULT 1;
    DECLARE strcur1 CHAR(1);
    DECLARE strnext1 CHAR(1);
    DECLARE strprev1 CHAR(1);
    DECLARE SlavoGermanic BOOLEAN DEFAULT 0;

    SET original = UPPER(COALESCE(str, ''));

    SET length_val = CHAR_LENGTH(original);
    SET last = length_val;

    IF original REGEXP '[WK]' OR LOCATE('CZ', original) > 0 OR LOCATE('WITZ', original) > 0 THEN
        SET SlavoGermanic = 1;
    END IF;

    IF SUBSTRING(original, 1, 2) IN ('GN', 'KN', 'PN', 'WR', 'PS') THEN
        SET current = current + 1;
    END IF;

    IF SUBSTRING(original, 1, 1) = 'X' THEN
        SET primary_code = CONCAT(primary_code, 'S');
        SET secondary_code = CONCAT(secondary_code, 'S');
        SET current = current + 1;
    END IF;

    IF SUBSTRING(original, 1, 1) IN ('A', 'E', 'I', 'O', 'U', 'Y') THEN
        SET primary_code = CONCAT(primary_code, 'A');
        SET secondary_code = CONCAT(secondary_code, 'A');
        SET current = current + 1;
    END IF;

    WHILE current <= length_val DO
        IF CHAR_LENGTH(primary_code) >= 5 THEN
            LEAVE;
        END IF;

        SET strcur1 = SUBSTRING(original, current, 1);
        SET strnext1 = SUBSTRING(original, current + 1, 1);
        SET strprev1 = CASE WHEN current > 1 THEN SUBSTRING(original, current - 1, 1) ELSE '' END;

        IF strcur1 IN ('A', 'E', 'I', 'O', 'U', 'Y') THEN
            SET current = current + 1;
        ELSEIF strcur1 = 'B' THEN
            SET primary_code = CONCAT(primary_code, 'P');
            SET secondary_code = CONCAT(secondary_code, 'P');
            IF strnext1 = 'B' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'Ç' THEN
            SET primary_code = CONCAT(primary_code, 'S');
            SET secondary_code = CONCAT(secondary_code, 'S');
            SET current = current + 1;
        ELSEIF strcur1 = 'C' THEN
            IF strnext1 = 'H' THEN
                IF SUBSTRING(original, current, 4) = 'CHIA' THEN
                    SET primary_code = CONCAT(primary_code, 'K');
                    SET secondary_code = CONCAT(secondary_code, 'K');
                ELSEIF current > 1 AND SUBSTRING(original, current, 4) = 'CHAE' THEN
                    SET primary_code = CONCAT(primary_code, 'K');
                    SET secondary_code = CONCAT(secondary_code, 'X');
                ELSEIF current = 1 AND (
                    SUBSTRING(original, current + 1, 5) IN ('HARAC', 'HARIS') OR
                    SUBSTRING(original, current + 1, 3) IN ('HOR', 'HYM', 'HIA', 'HEM')
                ) AND SUBSTRING(original, 1, 5) <> 'CHORE' THEN
                    SET primary_code = CONCAT(primary_code, 'K');
                    SET secondary_code = CONCAT(secondary_code, 'K');
                ELSEIF (SUBSTRING(original, 1, 4) IN ('VAN ', 'VON ') OR SUBSTRING(original, 1, 3) = 'SCH') OR
                       SUBSTRING(original, current - 2, 6) IN ('ORCHES', 'ARCHIT', 'ORCHID') OR
                       SUBSTRING(original, current + 2, 1) IN ('T', 'S') OR
                       ((strprev1 IN ('A','O','U','E') OR current = 0) AND
                        SUBSTRING(original, current + 2, 1) IN ('L','R','N','M','B','H','F','V','W',' ')) THEN
                    SET primary_code = CONCAT(primary_code, 'K');
                    SET secondary_code = CONCAT(secondary_code, 'K');
                ELSE
                    IF current > 1 THEN
                        IF SUBSTRING(original, 1, 2) = 'MC' THEN
                            SET primary_code = CONCAT(primary_code, 'K');
                            SET secondary_code = CONCAT(secondary_code, 'K');
                        ELSE
                            SET primary_code = CONCAT(primary_code, 'X');
                            SET secondary_code = CONCAT(secondary_code, 'K');
                        END IF;
                    ELSE
                        SET primary_code = CONCAT(primary_code, 'X');
                        SET secondary_code = CONCAT(secondary_code, 'X');
                    END IF;
                END IF;
                SET current = current + 2;
            ELSEIF strnext1 IN ('I', 'E', 'Y') THEN
                IF SUBSTRING(original, current, 3) IN ('CIO','CIE','CIA') THEN
                    SET primary_code = CONCAT(primary_code, 'S');
                    SET secondary_code = CONCAT(secondary_code, 'X');
                ELSE
                    SET primary_code = CONCAT(primary_code, 'S');
                    SET secondary_code = CONCAT(secondary_code, 'S');
                END IF;
                SET current = current + 2;
                        ELSEIF strnext1 = 'C' AND NOT (SUBSTRING(original, current + 2, 1) IN ('I','E','H')) THEN
                SET primary_code = CONCAT(primary_code, 'K');
                SET secondary_code = CONCAT(secondary_code, 'K');
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'K');
                SET secondary_code = CONCAT(secondary_code, 'K');
                IF strnext1 IN ('C','K','Q') THEN
                    SET current = current + 2;
                ELSE
                    SET current = current + 1;
                END IF;
            END IF;
        ELSEIF strcur1 = 'D' THEN
            IF strnext1 = 'G' AND SUBSTRING(original, current + 2, 1) IN ('I','E','Y') THEN
                SET primary_code = CONCAT(primary_code, 'J');
                SET secondary_code = CONCAT(secondary_code, 'J');
                SET current = current + 3;
            ELSEIF strnext1 = 'T' OR strnext1 = 'D' THEN
                SET primary_code = CONCAT(primary_code, 'T');
                SET secondary_code = CONCAT(secondary_code, 'T');
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'T');
                SET secondary_code = CONCAT(secondary_code, 'T');
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'F' THEN
            SET primary_code = CONCAT(primary_code, 'F');
            SET secondary_code = CONCAT(secondary_code, 'F');
            IF strnext1 = 'F' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'G' THEN
            IF strnext1 = 'H' THEN
                IF current > 1 AND NOT SUBSTRING(original, current - 2, 1) IN ('A','E','I','O','U','Y') THEN
                    SET primary_code = CONCAT(primary_code, 'K');
                    SET secondary_code = CONCAT(secondary_code, 'K');
                    SET current = current + 2;
                ELSEIF current = 1 THEN
                    IF SUBSTRING(original, current + 2, 1) = 'I' THEN
                        SET primary_code = CONCAT(primary_code, 'J');
                        SET secondary_code = CONCAT(secondary_code, 'J');
                        SET current = current + 2;
                    ELSE
                        SET primary_code = CONCAT(primary_code, 'K');
                        SET secondary_code = CONCAT(secondary_code, 'K');
                        SET current = current + 2;
                    END IF;
                ELSE
                    SET current = current + 2;
                END IF;
            ELSEIF strnext1 = 'N' THEN
                IF current = 1 AND original = 'GN' THEN
                    SET primary_code = CONCAT(primary_code, 'N');
                    SET secondary_code = CONCAT(secondary_code, 'N');
                ELSE
                    SET primary_code = CONCAT(primary_code, 'KN');
                    SET secondary_code = CONCAT(secondary_code, 'N');
                END IF;
                SET current = current + 2;
            ELSEIF SUBSTRING(original, current + 1, 2) = 'LI' AND NOT SlavoGermanic THEN
                SET primary_code = CONCAT(primary_code, 'KL');
                SET secondary_code = CONCAT(secondary_code, 'L');
                SET current = current + 2;
            ELSEIF current = 1 AND (strnext1 = 'Y' OR SUBSTRING(original, current + 1, 2) IN ('EY','I','E','Y')) THEN
                SET primary_code = CONCAT(primary_code, 'K');
                SET secondary_code = CONCAT(secondary_code, 'J');
                SET current = current + 2;
            ELSEIF SUBSTRING(original, current + 1, 2) IN ('ER','Y') THEN
                SET primary_code = CONCAT(primary_code, 'K');
                SET secondary_code = CONCAT(secondary_code, 'J');
                SET current = current + 2;
            ELSEIF strnext1 IN ('E','I','Y') OR strnext1 = 'G' THEN
                SET primary_code = CONCAT(primary_code, 'J');
                SET secondary_code = CONCAT(secondary_code, 'J');
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'K');
                SET secondary_code = CONCAT(secondary_code, 'K');
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'H' THEN
            IF (current = 1 OR SUBSTRING(original, current - 1, 1) NOT IN ('A','E','I','O','U')) AND
               SUBSTRING(original, current + 1, 1) IN ('A','E','I','O','U') THEN
                SET primary_code = CONCAT(primary_code, 'H');
                SET secondary_code = CONCAT(secondary_code, 'H');
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'J' THEN
            IF current = 1 THEN
                SET primary_code = CONCAT(primary_code, 'J');
                SET secondary_code = CONCAT(secondary_code, 'A');
            ELSEIF SUBSTRING(original, current - 1, 1) IN ('A','E','I','O','U') AND NOT SlavoGermanic THEN
                SET primary_code = CONCAT(primary_code, 'J');
                SET secondary_code = CONCAT(secondary_code, 'H');
            ELSEIF current = last THEN
                SET primary_code = CONCAT(primary_code, '');
                SET secondary_code = CONCAT(secondary_code, 'J');
            ELSE
                SET primary_code = CONCAT(primary_code, 'J');
                SET secondary_code = CONCAT(secondary_code, 'J');
            END IF;
            IF strnext1 = 'J' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'K' THEN
            SET primary_code = CONCAT(primary_code, 'K');
            SET secondary_code = CONCAT(secondary_code, 'K');
            IF strnext1 = 'K' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'L' THEN
            SET primary_code = CONCAT(primary_code, 'L');
            SET secondary_code = CONCAT(secondary_code, 'L');
            IF strnext1 = 'L' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'M' THEN
            SET primary_code = CONCAT(primary_code, 'M');
            SET secondary_code = CONCAT(secondary_code, 'M');
            IF (strnext1 = 'M') OR (SUBSTRING(original, current - 1, 3) = 'UMB' AND (current + 1 = last OR SUBSTRING(original, current + 2, 1) = ' ')) THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'N' THEN
            SET primary_code = CONCAT(primary_code, 'N');
            SET secondary_code = CONCAT(secondary_code, 'N');
            IF strnext1 = 'N' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'P' THEN
            IF strnext1 = 'H' THEN
                SET primary_code = CONCAT(primary_code, 'F');
                SET secondary_code = CONCAT(secondary_code, 'F');
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'P');
                SET secondary_code = CONCAT(secondary_code, 'P');
                IF strnext1 = 'P' THEN
                    SET current = current + 2;
                ELSE
                    SET current = current + 1;
                END IF;
            END IF;
                ELSEIF strcur1 = 'Q' THEN
            SET primary_code = CONCAT(primary_code, 'K');
            SET secondary_code = CONCAT(secondary_code, 'K');
            IF strnext1 = 'Q' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'R' THEN
            SET primary_code = CONCAT(primary_code, 'R');
            SET secondary_code = CONCAT(secondary_code, 'R');
            IF strnext1 = 'R' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'S' THEN
            IF SUBSTRING(original, current + 1, 2) = 'IO' OR SUBSTRING(original, current + 1, 2) = 'IA' THEN
                SET primary_code = CONCAT(primary_code, 'X');
                SET secondary_code = CONCAT(secondary_code, 'X');
                SET current = current + 3;
            ELSEIF strnext1 = 'H' THEN
                SET primary_code = CONCAT(primary_code, 'X');
                SET secondary_code = CONCAT(secondary_code, 'X');
                SET current = current + 2;
            ELSEIF SUBSTRING(original, current + 1, 1) IN ('I','E','Y') THEN
                IF SUBSTRING(original, current, 3) IN ('CIO','CIE','CIA') THEN
                    SET primary_code = CONCAT(primary_code, 'S');
                    SET secondary_code = CONCAT(secondary_code, 'X');
                ELSE
                    SET primary_code = CONCAT(primary_code, 'S');
                    SET secondary_code = CONCAT(secondary_code, 'S');
                END IF;
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'S');
                SET secondary_code = CONCAT(secondary_code, 'S');
                IF strnext1 = 'S' THEN
                    SET current = current + 2;
                ELSE
                    SET current = current + 1;
                END IF;
            END IF;
        ELSEIF strcur1 = 'T' THEN
            IF SUBSTRING(original, current + 1, 2) = 'IA' OR SUBSTRING(original, current + 1, 2) = 'IO' THEN
                SET primary_code = CONCAT(primary_code, 'X');
                SET secondary_code = CONCAT(secondary_code, 'X');
                SET current = current + 3;
            ELSEIF strnext1 = 'H' THEN
                SET primary_code = CONCAT(primary_code, '0');
                SET secondary_code = CONCAT(secondary_code, 'T');
                SET current = current + 2;
            ELSEIF SUBSTRING(original, current + 1, 2) = 'CH' THEN
                SET primary_code = CONCAT(primary_code, 'K');
                SET secondary_code = CONCAT(secondary_code, 'K');
                SET current = current + 2;
            ELSE
                SET primary_code = CONCAT(primary_code, 'T');
                SET secondary_code = CONCAT(secondary_code, 'T');
                IF strnext1 = 'T' OR strnext1 = 'D' THEN
                    SET current = current + 2;
                ELSE
                    SET current = current + 1;
                END IF;
            END IF;
        ELSEIF strcur1 = 'V' THEN
            SET primary_code = CONCAT(primary_code, 'F');
            SET secondary_code = CONCAT(secondary_code, 'F');
            IF strnext1 = 'V' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'W' OR strcur1 = 'Y' THEN
            IF current < last AND SUBSTRING(original, current + 1, 1) IN ('A','E','I','O','U') THEN
                SET primary_code = CONCAT(primary_code, strcur1);
                SET secondary_code = CONCAT(secondary_code, strcur1);
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSEIF strcur1 = 'X' THEN
            SET primary_code = CONCAT(primary_code, 'KS');
            SET secondary_code = CONCAT(secondary_code, 'KS');
            SET current = current + 1;
        ELSEIF strcur1 = 'Z' THEN
            SET primary_code = CONCAT(primary_code, 'S');
            SET secondary_code = CONCAT(secondary_code, 'S');
            IF strnext1 = 'Z' THEN
                SET current = current + 2;
            ELSE
                SET current = current + 1;
            END IF;
        ELSE
            SET current = current + 1;
        END IF;
    END WHILE;

    RETURN CONCAT(primary_code, '|', secondary_code);
END$$

DELIMITER ;
