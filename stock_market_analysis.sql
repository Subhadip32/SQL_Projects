-- CREATE DATABASE 
CREATE DATABASE stock_market_analysis;

-- USE DATABASE
USE stock_market_analysis;

-- TABLE CREATION
CREATE TABLE tesla_stock_data_2010_2025 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    stock_date DATE,
    open_price DECIMAL(10,2),
    high_price DECIMAL(10,2),
    low_price DECIMAL(10,2),
    close_price DECIMAL(10,2),
    volume BIGINT);

CREATE TABLE tesla_stock LIKE tesla_stock_data_2010_2025;		-- MAKE CLONE TABLE
INSERT tesla_stock SELECT * FROM tesla_stock_data_2010_2025;	-- INSERT DATA

-- SHOW ALL COLUMNS AND TABLE
SELECT * FROM tesla_stock;

-- FIND HIGHEST
SELECT `Date`, Volume FROM
	tesla_stock
	ORDER BY Volume DESC;

-- MOVING AVERAGE (6 PRECEDING)
SELECT `Date`, Volume, AVG(Volume) OVER(ORDER BY `Date` ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) 
moving_avg FROM tesla_stock;

-- DETECT SUSPICIOUS VOLUME
WITH volume_analysis AS (SELECT `Date`, volume, AVG(volume) OVER(ORDER BY `Date` ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
) AS moving_avg
	FROM tesla_stock)
	SELECT `Date`, volume, moving_avg,
	CASE WHEN volume > moving_avg * 3 THEN 'Suspicious'
	ELSE 'Normal'
	END AS activity_status FROM volume_analysis;

-- PREVIOUS DAY PRICE
SELECT `Date`, Close, LAG(Close) 
	OVER( ORDER BY `Date`) previous_close 
	FROM tesla_stock;

-- ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci (Saving Engine)