--1. Fills empty (NULL) rating columns with the average rating of all non-NULL entries.

SELECT *
FROM smartphone

SELECT rating 
FROM smartphone

UPDATE smartphone
SET rating = (
    SELECT ROUND(AVG(rating), 1) FROM (SELECT rating FROM smartphone WHERE rating IS NOT NULL) AS temp
)
WHERE rating IS NULL;

SELECT rating
FROM smartphone
WHERE rating IS NULL

--2. Fill the NULL processor_brand column with 'Unknown'

SELECT processor_brand
FROM smartphone
WHERE processor_brand IS NULL

UPDATE smartphone
SET processor_brand = 'Unknown'
WHERE processor_brand IS NULL;

SELECT processor_brand
FROM smartphone
WHERE processor_brand ='Unknown'


--3. Fill the NULL battery_capacity with the Average capacity (assume 5000 mAh)

SELECT battery_capacity
FROM smartphone
WHERE battery_capacity IS NULL

SELECT ROUND(AVG(battery_capacity), 0) 
FROM smartphone 
WHERE battery_capacity IS NOT NULL
-- AVG battery_capacity is 4.867 and rounded up to 5000 mAh

UPDATE smartphone
SET battery_capacity = 5000
WHERE battery_capacity IS NULL;



--4.  • If fast_charging_available = 1 and fast_charging IS NULL, fill with the default value (assume 33 watts)
--  If fast_charging_available = 0, fill NULL to 0


SELECT *
FROM smartphone

SELECT COUNT(fast_charging), fast_charging_available
FROM smartphone
WHERE fast_charging = '33' 
GROUP BY fast_charging_available


UPDATE smartphone
SET fast_charging = 33
WHERE fast_charging IS NULL AND fast_charging_available = 1;

UPDATE smartphone
SET fast_charging = 0
WHERE fast_charging IS NULL AND fast_charging_available = 0;

SELECT fast_charging, fast_charging_available
FROM smartphone


--5. Fill the NULL os with 'android' (assuming the majority of OS is Android)

SELECT os
FROM smartphone
WHERE os IS NULL

UPDATE smartphone
SET os = 'android'
WHERE os IS NULL;


